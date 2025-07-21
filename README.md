# SMARTMobs - Your Best Cash Partner

A Flutter mobile application for financial management and cash transactions.

## Features

- **Splash Screen**: Beautiful welcome screen with app branding
- **Onboarding**: 4-step introduction to app features
- **Login Screen**: Secure authentication with phone/username and password
- **Modern UI**: Clean, responsive design with Material Design 3
- **Cross Platform**: Works on both iOS and Android

## Screenshots

### Splash Screen
- App logo and branding
- "SMARTMobs - Your Best Cash Partner" tagline
- Powered by MenaMedia footer

### Onboarding Screens
1. **Welcome**: Introduction to SMARTMobs
2. **Saving Your Money**: Secure and transparent saving features
3. **Easy, Fast & Trusted**: Speed and reliability highlights
4. **Flexible Transactions**: Payment and transaction flexibility

### Login Screen
- Phone number or username input
- Password input with visibility toggle
- Forgot password functionality
- Sign up option for new users

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Android Emulator or Physical Device
- iOS Simulator (for iOS development)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd smart-mob
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

### Build for Production

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

## Project Structure

```
lib/
├── constants/
│   ├── app_colors.dart      # Color definitions
│   └── app_text.dart        # Text constants
├── screens/
│   ├── splash_screen.dart   # Splash screen
│   ├── onboarding_screen.dart # Onboarding flow
│   └── login_screen.dart    # Login screen
├── widgets/                 # Reusable widgets
└── main.dart               # App entry point
```

## Dependencies

- `flutter`: Core Flutter framework
- `google_fonts`: Custom typography
- `introduction_screen`: Onboarding flow
- `shared_preferences`: Local data storage
- `cupertino_icons`: iOS-style icons

## Design System

### Colors
- **Primary Red**: #E53E3E
- **Primary Blue**: #3182CE
- **Primary Purple**: #805AD5
- **Text Black**: #1A202C
- **Text Gray**: #718096
- **Background White**: #FFFFFF

### Typography
- **Font Family**: Poppins (Google Fonts)
- **Headings**: Bold, 24-32px
- **Body Text**: Regular, 16px
- **Caption**: Light, 12-14px

## Development

### Code Style
- Follow Flutter/Dart conventions
- Use meaningful variable and function names
- Include proper error handling
- Add comments for complex logic

### State Management
- Currently using StatefulWidget for local state
- Ready for integration with state management solutions (Provider, Bloc, Riverpod)

## Future Enhancements

- [ ] User registration screen
- [ ] Dashboard/home screen
- [ ] Transaction history
- [ ] Settings screen
- [ ] Profile management
- [ ] Push notifications
- [ ] Biometric authentication
- [ ] Dark mode support

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please contact the development team.

---

**SMARTMobs** - Your Best Cash Partner
*Powered by MenaMedia*
