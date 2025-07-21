import 'package:flutter/material.dart';

class AppText {
  // App name and tagline
  static const String appName = "SMARTMobs";
  static const String appTagline = "Your Best Cash Partner";
  static const String poweredBy = "Secured by";
  static const String merahPutih = "MerahPutih";

  // Onboarding texts
  static const String welcomeTitle = "Welcome to SMARTMobs";
  static const String getStarted = "Get Started";
  static const String continueText = "Continue";

  // Onboarding screen 1
  static const String onboarding1Title = "Welcome to SMARTMobs";

  // Onboarding screen 2
  static const String onboarding2Title = "Saving Your Money";
  static const String onboarding2Description =
      "Track the progress of your savings and start a habit of saving with SMARTMobs";

  // Onboarding screen 3
  static const String onboarding3Title = "Easy, Fast & Trusted";
  static const String onboarding3Description =
      "Money transfer and payment safe transactions with others.";

  // Onboarding screen 4
  static const String onboarding4Title = "Flexible transactions";
  static const String onboarding4Description =
      "Cash or non cash deposit, transfer, pickup and delivery packages can be done anywhere in a safe of SMARTMobs.";

  // Login texts
  static const String loginTitle = "Log in";
  static const String phoneNumberPlaceholder = "Phone Number or Username";
  static const String passwordPlaceholder = "Password";
  static const String forgotPassword = "Forgot Password?";
  static const String loginButton = "Log in";
}

// Extension untuk styling SMARTMobs text
extension SmartMobsTextStyle on AppText {
  static TextStyle getSmartMobsStyle({double fontSize = 32, Color? color}) {
    return TextStyle(
      fontFamily: 'Abhaya Libre',
      fontWeight: FontWeight.w500,
      fontSize: fontSize,
      color: color,
    );
  }
}
