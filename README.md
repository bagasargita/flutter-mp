# SMARTMobs - Your Best Cash Partner

A modern Flutter mobile application built with Clean Architecture principles, featuring comprehensive state management, API integration, and scalable code structure.

## 📱 Features

- **Authentication System**: Secure login/register with token management
- **Home Dashboard**: Service discovery and quick access to features
- **Profile Management**: User profile viewing and editing
- **Notifications**: Real-time notification system
- **Clean Architecture**: Scalable and maintainable code structure
- **State Management**: Riverpod for reactive state management
- **API Integration**: Dio with interceptors for HTTP requests
- **Error Handling**: Functional programming with Either type

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a feature-based folder structure:

```
lib/
├── core/                           # Core utilities and shared components
│   ├── api/                       # API layer
│   │   ├── api_client.dart        # HTTP client implementation
│   │   ├── api_endpoints.dart     # API endpoint constants
│   │   └── interceptors/          # HTTP interceptors
│   │       ├── auth_interceptor.dart
│   │       └── logging_interceptor.dart
│   ├── di/                        # Dependency injection
│   │   └── injection.dart         # Riverpod providers setup
│   ├── error/                     # Error handling
│   │   └── failures.dart          # Custom failure types
│   └── utils/                     # Utility classes
│       └── either.dart            # Functional Either type
├── features/                      # Feature-based modules
│   ├── auth/                      # Authentication feature
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       └── register_usecase.dart
│   │   └── presentation/
│   │       └── providers/
│   │           └── auth_provider.dart
│   ├── home/                      # Home feature
│   ├── profile/                   # Profile feature
│   └── notifications/             # Notifications feature
├── screens/                       # UI screens
├── constants/                     # App constants
└── shared/                        # Shared components
    └── widgets/                   # Reusable widgets
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK (3.8.1 or higher)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/smart-mob.git
   cd smart-mob
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Build APK

```bash
flutter build apk --release
```

## 📦 Dependencies

### Core Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_riverpod` | ^2.4.0 | State management |
| `dio` | ^5.4.0 | HTTP client |
| `shared_preferences` | ^2.2.2 | Local storage |
| `google_fonts` | ^6.1.0 | Typography |
| Custom Implementation | - | Onboarding |

### Development Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `build_runner` | ^2.4.7 | Code generation |
| `json_serializable` | ^6.7.1 | JSON serialization |
| `retrofit_generator` | ^8.0.4 | API client generation |
| `riverpod_generator` | ^2.3.9 | Riverpod code generation |
| `freezed` | ^2.4.6 | Immutable classes |

## 🏛️ Architecture Details

### Clean Architecture Layers

#### 1. **Domain Layer** (Business Logic)
- **Entities**: Core business objects (e.g., `User`)
- **Repositories**: Abstract interfaces for data access
- **Use Cases**: Business logic implementation

#### 2. **Data Layer** (Data Access)
- **Repository Implementations**: Concrete implementations of domain repositories
- **Data Sources**: API clients, local storage
- **Data Models**: Data transfer objects

#### 3. **Presentation Layer** (UI)
- **Providers**: State management with Riverpod
- **Screens**: UI components
- **Widgets**: Reusable UI components

### State Management

The app uses **Riverpod** for state management with the following pattern:

```dart
// State class
class AuthState {
  final bool isLoading;
  final User? user;
  final String? error;
  final bool isAuthenticated;
  
  const AuthState({
    this.isLoading = false,
    this.user,
    this.error,
    this.isAuthenticated = false,
  });
}

// State notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  
  AuthNotifier({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(const AuthState());
        
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _loginUseCase(email: email, password: password);
    
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (user) => state = state.copyWith(isLoading: false, user: user, isAuthenticated: true),
    );
  }
}
```

### Error Handling

The app implements functional error handling using the `Either` type:

```dart
// Failure types
abstract class Failure {
  const Failure();
  String get message;
}

class ServerFailure extends Failure {
  @override
  final String message;
  final int? statusCode;
  
  const ServerFailure({required this.message, this.statusCode});
}

// Usage in repositories
Future<Either<Failure, User>> login({
  required String email,
  required String password,
}) async {
  try {
    final response = await _apiClient.login(credentials: {
      'email': email,
      'password': password,
    });
    
    final user = User.fromJson(response.data!['user']);
    return Right(user);
  } on DioException catch (e) {
    return Left(ServerFailure(message: e.message ?? 'Login failed'));
  } catch (e) {
    return Left(NetworkFailure(message: 'Network error occurred'));
  }
}
```

### API Integration

The app uses **Dio** with custom interceptors:

```dart
class ApiClient {
  final Dio _dio;
  
  static ApiClient create() {
    final dio = Dio();
    dio.interceptors.addAll([
      LoggingInterceptor(),
      AuthInterceptor(),
    ]);
    return ApiClient(dio);
  }
  
  Future<Response<Map<String, dynamic>>> login({
    required Map<String, dynamic> credentials,
  }) async {
    return await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: credentials,
    );
  }
}
```

## 🔧 Configuration

### Environment Setup

1. **API Configuration**
   - Update `lib/core/api/api_endpoints.dart` with your API base URL
   - Configure authentication endpoints as needed

2. **Theme Configuration**
   - Customize colors in `lib/constants/app_colors.dart`
   - Update typography in `lib/constants/app_text.dart`

3. **Assets**
   - Add images to `assets/images/`
   - Add fonts to `assets/fonts/`

### Code Generation

Run code generation when making changes to:
- API client annotations
- JSON serialization
- Riverpod providers

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 🧪 Testing

### Unit Tests

```bash
flutter test
```

### Widget Tests

```bash
flutter test test/widget_test.dart
```

## 📱 Screenshots

[Add screenshots of your app here]

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow Dart/Flutter conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused
- Use proper error handling

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

If you encounter any issues:

1. Check the [Issues](https://github.com/your-username/smart-mob/issues) page
2. Create a new issue with detailed information
3. Include error logs and steps to reproduce

## 🔄 Version History

- **v1.0.0** - Initial release with basic features
- **v1.1.0** - Added authentication system
- **v1.2.0** - Implemented clean architecture
- **v1.3.0** - Added notifications feature

## 📞 Contact

- **Developer**: [Your Name]
- **Email**: [your.email@example.com]
- **GitHub**: [@your-username]

---

**Made with ❤️ using Flutter and Clean Architecture**
