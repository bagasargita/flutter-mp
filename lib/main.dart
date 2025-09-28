import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constants/app_colors.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/setor_tunai/setor_tunai_history_screen.dart';
import 'screens/setor_tunai/setor_tunai_location_screen.dart';
import 'features/app/presentation/bloc/app_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/notifications/presentation/bloc/notifications_bloc.dart';
import 'widgets/common/app_bottom_nav.dart';
import 'core/di/service_locator.dart';
import 'shared/widgets/account_menu_widget.dart';
import 'shared/widgets/bottom_nav_mapper.dart';
import 'screens/mesin/komisi_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator().init();

  // Initialize permissions early in app lifecycle
  await ServiceLocator().permissionService.initializePermissions();

  runApp(const MyApp());
}

// Global function to clear authentication state
Future<void> clearAuthState(BuildContext context) async {
  print('Clearing all authentication and app states...');

  try {
    // Clear AppBloc state first
    context.read<AppBloc>().add(const AppLogoutRequested());
    print('AppBloc logout requested');

    // Clear AuthBloc state (this also clears SharedPreferences)
    context.read<AuthBloc>().add(const AuthLogoutRequested());
    print('AuthBloc logout requested');

    // Wait for all async operations to complete
    await Future.delayed(const Duration(milliseconds: 800));

    // Double-check that SharedPreferences are cleared by directly accessing the repository
    try {
      final authRepo = ServiceLocator().authRepository;
      await authRepo.clearUser();
      print('Additional clearUser call completed');
    } catch (e) {
      print('Error in additional clearUser: $e');
    }

    // Show success toast notification
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Berhasil keluar dari akun',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          backgroundColor: AppColors.primaryRed,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }

    print('All states cleared successfully');
  } catch (e) {
    print('Error clearing states: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppBloc()),
        BlocProvider(
          create: (context) => AuthBloc(ServiceLocator().authRepository),
        ),
        BlocProvider(create: (context) => NotificationsBloc()),
      ],
      child: MaterialApp(
        title: 'MerahPutih',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryRed,
            brightness: Brightness.light,
          ),
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: AppColors.textBlack,
            displayColor: AppColors.textBlack,
          ),
          useMaterial3: true,
        ),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(1.0)),
            child: child!,
          );
        },
        routes: {'/notifications': (context) => const NotificationsScreen()},
        home: const AppEntry(),
      ),
    );
  }
}

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  @override
  void initState() {
    super.initState();
    // Initialize the app and check for saved authentication
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AppBloc>().add(const AppInitialized());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen: (previous, current) {
        return true;
      },
      builder: (context, state) {
        if (state.showSplash) {
          final blocContext = context;
          Future.delayed(const Duration(seconds: 2), () {
            if (blocContext.mounted) {
              blocContext.read<AppBloc>().add(const AppSplashFinished());
            }
          });
          return const SplashScreen();
        }
        if (!state.hasSeenOnboarding) {
          return const OnboardingScreen();
        }
        if (!state.isAuthenticated) {
          return LoginScreen(
            onLoginSuccess:
                (
                  String userRoleMobile,
                  String userEmail,
                  String userName,
                  String selectedRole,
                ) {
                  context.read<AppBloc>().add(
                    AppLoginSuccess(
                      userRoleMobile: userRoleMobile,
                      userEmail: userEmail,
                      userName: userName,
                      selectedRole: selectedRole,
                    ),
                  );
                },
          );
        }

        // For MESIN/NON_MESIN users without selectedRole, go to role selection
        // CUSTOMER users should skip role selection entirely
        if ((state.userRoleMobile == 'MESIN' ||
                state.userRoleMobile == 'NON_MESIN') &&
            state.selectedRole.isEmpty) {
          print(
            'Main: Navigating to role selection for ${state.userRoleMobile}',
          );
          return RoleSelectionScreen(
            userEmail: state.userEmail,
            userName: state.userName,
            userRoleMobile: state.userRoleMobile,
            selectedRole: state.selectedRole,
          );
        }

        print(
          'Main: Navigating to RootScreen - Role: ${state.userRoleMobile}, SelectedRole: ${state.selectedRole}',
        );

        return RootScreen(
          userRoleMobile: state.userRoleMobile,
          userEmail: state.userEmail,
          userName: state.userName,
          selectedRole: state.selectedRole,
        );
      },
    );
  }
}

class RootScreen extends StatefulWidget {
  final String userRoleMobile;
  final String userEmail;
  final String userName;
  final String selectedRole;
  const RootScreen({
    super.key,
    required this.userRoleMobile,
    required this.userEmail,
    required this.userName,
    required this.selectedRole,
  });

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;
  late List<BottomNavItemData> _items;

  @override
  void initState() {
    super.initState();
    _items = _getBottomNavItems();
    _screens = _buildScreens(_items);
  }

  @override
  void didUpdateWidget(covariant RootScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedRole != widget.selectedRole ||
        oldWidget.userRoleMobile != widget.userRoleMobile) {
      _items = _getBottomNavItems();
      _screens = _buildScreens(_items);
      if (_selectedIndex > _screens.length - 1) {
        _selectedIndex = 0;
      }
    }
  }

  List<Widget> _buildScreens(List<BottomNavItemData> items) {
    final List<Widget> screens = [];
    for (final item in items) {
      if (item.label == 'Beranda') {
        screens.add(
          HomeScreen(
            userRoleMobile: widget.userRoleMobile,
            userEmail: widget.userEmail,
            userName: widget.userName,
            selectedRole: widget.selectedRole,
          ),
        );
      } else if (item.label == 'Lokasi') {
        screens.add(const SetorTunaiLocationScreen());
      } else if (item.label == 'Riwayat Transaksi' ||
          item.label == 'Riwayat' ||
          item.label == 'Riwayat Layanan') {
        screens.add(const SetorTunaiHistoryScreen());
      } else if (item.label == 'Komisi' || item.label == 'KOMISI') {
        screens.add(const KomisiScreen());
      } else if (item.label == 'Akun') {
        screens.add(
          const Center(child: Text('Akun', style: TextStyle(fontSize: 24))),
        );
      } else {
        screens.add(const SizedBox.shrink());
      }
    }
    return screens;
  }

  void _onItemTapped(int index) {
    if (index < 0 || index >= _items.length) {
      return;
    }
    final tappedItem = _items[index];
    if (tappedItem.label == 'Akun') {
      AccountMenuWidget.showMoreMenu(context);
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  List<BottomNavItemData> _getBottomNavItems() {
    return BottomNavMapper.getBottomNavItems(
      selectedRole: widget.selectedRole,
      userRoleMobile: widget.userRoleMobile,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: AppBottomNav(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: _items,
        ),
      ),
    );
  }

  // removed: replaced by AppBottomNav
}
