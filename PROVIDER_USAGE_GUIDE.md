# Provider Usage Guide

This guide shows how to use Riverpod providers in your Flutter screens with the Clean Architecture pattern.

## 📋 Table of Contents

1. [Basic Provider Usage](#basic-provider-usage)
2. [Authentication Provider](#authentication-provider)
3. [Home Provider](#home-provider)
4. [Profile Provider](#profile-provider)
5. [Notifications Provider](#notifications-provider)
6. [Best Practices](#best-practices)
7. [Common Patterns](#common-patterns)

## 🔧 Basic Provider Usage

### Step 1: Convert to ConsumerStatefulWidget

```dart
// Before
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

// After
class MyScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}
```

### Step 2: Watch and Listen to Providers

```dart
class _MyScreenState extends ConsumerState<MyScreen> {
  @override
  Widget build(BuildContext context) {
    // Watch provider state
    final state = ref.watch(myProvider);
    
    // Listen to state changes
    ref.listen<MyState>(myProvider, (previous, next) {
      if (next.isSuccess) {
        // Handle success
        Navigator.push(context, MaterialPageRoute(builder: (_) => SuccessScreen()));
      } else if (next.error != null) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      body: state.isLoading 
        ? CircularProgressIndicator()
        : YourContent(),
    );
  }
}
```

## 🔐 Authentication Provider

### Usage in Login Screen

```dart
class LoginScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authNotifierProvider.notifier).login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Listen to authentication state changes
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.isAuthenticated && next.user != null) {
        // Navigate to home on successful login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (next.error != null) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      body: Form(
        child: Column(
          children: [
            TextFormField(controller: _emailController),
            TextFormField(controller: _passwordController),
            ElevatedButton(
              onPressed: authState.isLoading ? null : _login,
              child: authState.isLoading 
                ? CircularProgressIndicator()
                : Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Key Features:
- **Loading State**: Show loading indicator during authentication
- **Error Handling**: Display error messages via SnackBar
- **Navigation**: Automatic navigation on successful login
- **Form Validation**: Validate inputs before submission

## 🏠 Home Provider

### Usage in Home Screen

```dart
class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeNotifierProvider.notifier).getServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeNotifierProvider);

    return Scaffold(
      body: homeState.isLoading
        ? Center(child: CircularProgressIndicator())
        : homeState.error != null
          ? _buildErrorContent(homeState.error!)
          : _buildServicesContent(homeState.services),
    );
  }

  Widget _buildServicesContent(List<Map<String, dynamic>> services) {
    return GridView.builder(
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return ServiceCard(service: service);
      },
    );
  }

  Widget _buildErrorContent(String error) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          Text('Failed to load services'),
          Text(error),
          ElevatedButton(
            onPressed: () {
              ref.read(homeNotifierProvider.notifier).getServices();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
```

### Key Features:
- **Auto-loading**: Load data when screen initializes
- **Loading States**: Show loading indicator
- **Error Handling**: Display error with retry option
- **Empty States**: Handle empty data gracefully

## 👤 Profile Provider

### Usage in Profile Screen

```dart
class ProfileScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      body: profileState.isLoading
        ? Center(child: CircularProgressIndicator())
        : profileState.user != null
          ? _buildProfileContent(profileState.user!)
          : _buildErrorContent(profileState.error),
    );
  }

  Widget _buildProfileContent(User user) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CircleAvatar(
            child: Text(user.name.substring(0, 1)),
          ),
          Text(user.name),
          Text(user.email),
          ListTile(
            title: Text('Edit Profile'),
            onTap: () => _showEditProfileDialog(),
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () => _logout(),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authNotifierProvider.notifier).logout();
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
```

### Key Features:
- **Profile Data**: Display user information
- **Edit Functionality**: Update profile data
- **Logout**: Clear authentication state
- **Error Handling**: Show error with retry option

## 🔔 Notifications Provider

### Usage in Notifications Screen

```dart
class NotificationsScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Load notifications
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationsNotifierProvider.notifier).getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationsState = ref.watch(notificationsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              // Mark all as read
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('All marked as read')),
              );
            },
            child: Text('Mark all read'),
          ),
        ],
      ),
      body: notificationsState.isLoading
        ? Center(child: CircularProgressIndicator())
        : notificationsState.error != null
          ? _buildErrorContent(notificationsState.error!)
          : _buildNotificationsContent(notificationsState.notifications),
    );
  }

  Widget _buildNotificationsContent(List<Map<String, dynamic>> notifications) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    // Group by date
    final today = notifications.where((n) => _isToday(n['created_at'])).toList();
    final week = notifications.where((n) => _isThisWeek(n['created_at'])).toList();

    return ListView(
      children: [
        if (today.isNotEmpty) ...[
          _buildSectionHeader('Today'),
          ...today.map((n) => _buildNotificationTile(n)),
        ],
        if (week.isNotEmpty) ...[
          _buildSectionHeader('This Week'),
          ...week.map((n) => _buildNotificationTile(n)),
        ],
      ],
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> notification) {
    final isRead = notification['is_read'] ?? false;
    
    return ListTile(
      leading: CircleAvatar(
        child: Icon(_getNotificationIcon(notification['type'])),
      ),
      title: Text(
        notification['title'],
        style: TextStyle(
          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Text(notification['message']),
      trailing: !isRead ? Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ) : null,
      onTap: () => _handleNotificationTap(notification),
    );
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    final type = notification['type'];
    
    switch (type) {
      case 'payment':
        // Navigate to payment screen
        break;
      case 'transfer':
        // Navigate to transfer screen
        break;
      default:
        // Show notification details
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(notification['title']),
            content: Text(notification['message']),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
        );
    }
  }
}
```

### Key Features:
- **Grouped Display**: Group notifications by date
- **Read/Unread States**: Visual indicators for unread notifications
- **Action Handling**: Navigate based on notification type
- **Empty States**: Handle no notifications gracefully

## 🎯 Best Practices

### 1. **State Management**
```dart
// ✅ Good: Watch state in build method
final state = ref.watch(myProvider);

// ✅ Good: Listen to state changes
ref.listen<MyState>(myProvider, (previous, next) {
  // Handle state changes
});

// ❌ Bad: Don't watch in initState
@override
void initState() {
  super.initState();
  ref.watch(myProvider); // This won't work
}
```

### 2. **Loading States**
```dart
// ✅ Good: Show loading indicator
if (state.isLoading) {
  return Center(child: CircularProgressIndicator());
}

// ✅ Good: Disable button during loading
ElevatedButton(
  onPressed: state.isLoading ? null : _submit,
  child: state.isLoading ? CircularProgressIndicator() : Text('Submit'),
)
```

### 3. **Error Handling**
```dart
// ✅ Good: Show error with retry option
Widget _buildErrorContent(String error) {
  return Center(
    child: Column(
      children: [
        Icon(Icons.error_outline),
        Text('Error: $error'),
        ElevatedButton(
          onPressed: () => ref.read(provider.notifier).retry(),
          child: Text('Retry'),
        ),
      ],
    ),
  );
}
```

### 4. **Empty States**
```dart
// ✅ Good: Handle empty data
if (data.isEmpty) {
  return Center(
    child: Column(
      children: [
        Icon(Icons.inbox_outlined),
        Text('No data available'),
      ],
    ),
  );
}
```

## 🔄 Common Patterns

### 1. **Auto-refresh Pattern**
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(provider.notifier).loadData();
  });
}
```

### 2. **Pull-to-refresh Pattern**
```dart
RefreshIndicator(
  onRefresh: () async {
    await ref.read(provider.notifier).refresh();
  },
  child: ListView.builder(
    itemBuilder: (context, index) => ListTile(
      title: Text(data[index].title),
    ),
  ),
)
```

### 3. **Search Pattern**
```dart
final searchController = TextEditingController();

void _search(String query) {
  ref.read(provider.notifier).search(query);
}

TextField(
  controller: searchController,
  onChanged: _search,
  decoration: InputDecoration(
    hintText: 'Search...',
  ),
)
```

### 4. **Pagination Pattern**
```dart
ListView.builder(
  itemCount: data.length + 1,
  itemBuilder: (context, index) {
    if (index == data.length) {
      if (state.hasMore) {
        ref.read(provider.notifier).loadMore();
        return Center(child: CircularProgressIndicator());
      } else {
        return SizedBox.shrink();
      }
    }
    return ListTile(title: Text(data[index].title));
  },
)
```

## 📝 Summary

Using providers in screens involves:

1. **Convert to ConsumerStatefulWidget**
2. **Watch provider state** in build method
3. **Listen to state changes** for side effects
4. **Handle loading, error, and empty states**
5. **Call provider methods** for actions
6. **Follow best practices** for clean code

This pattern provides:
- ✅ **Reactive UI**: Automatic updates when state changes
- ✅ **Clean separation**: Business logic in providers, UI in screens
- ✅ **Error handling**: Graceful error states
- ✅ **Loading states**: Better user experience
- ✅ **Testability**: Easy to test providers independently

---

**Remember**: Always handle loading, error, and empty states to provide a great user experience! 🚀 