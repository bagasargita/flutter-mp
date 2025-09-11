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
import 'features/app/presentation/bloc/app_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/notifications/presentation/bloc/notifications_bloc.dart';
import 'widgets/common/app_bottom_nav.dart';
import 'core/di/service_locator.dart';
import 'shared/widgets/account_menu_widget.dart';
import 'shared/widgets/bottom_nav_mapper.dart';

void main() {
  ServiceLocator().init();
  runApp(const MyApp());
}

// Global function to clear authentication state
Future<void> clearAuthState(BuildContext context) async {
  print('Clearing authentication state...');

  // First, clear AppBloc state to prevent any UI issues
  context.read<AppBloc>().add(const AppLogoutRequested());

  // Clear AuthBloc state (this also clears SharedPreferences)
  context.read<AuthBloc>().add(const AuthLogoutRequested());

  // Wait longer for all async operations to complete
  await Future.delayed(const Duration(milliseconds: 500));

  // Double-check that SharedPreferences are cleared by directly accessing the repository
  try {
    final authRepo = ServiceLocator().authRepository;
    await authRepo.clearUser();
    print('Additional clearUser call completed');
  } catch (e) {
    print('Error in additional clearUser: $e');
  }

  print('Authentication state cleared successfully');
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
        // Always rebuild when authentication state changes
        print(
          'BlocBuilder buildWhen - Previous: ${previous.isAuthenticated}, Current: ${current.isAuthenticated}',
        );
        return true;
      },
      builder: (context, state) {
        print(
          'AppEntry State - Auth: ${state.isAuthenticated}, Role: ${state.userRoleMobile}, SelectedRole: ${state.selectedRole}',
        );
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

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        userRoleMobile: widget.userRoleMobile,
        userEmail: widget.userEmail,
        userName: widget.userName,
        selectedRole: widget.selectedRole,
      ),
      const SetorTunaiHistoryScreen(),
      const Center(child: Text('Akun', style: TextStyle(fontSize: 24))),
    ];
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      // Index 2 is the "Akun" tab
      AccountMenuWidget.showMoreMenu(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
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
      child: BlocProvider(
        create: (context) => HomeBloc(),
        child: Scaffold(
          body: _screens[_selectedIndex],
          bottomNavigationBar: AppBottomNav(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: _getBottomNavItems(),
          ),
        ),
      ),
    );
  }

  // removed: replaced by AppBottomNav
}
