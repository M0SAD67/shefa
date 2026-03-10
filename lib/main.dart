import 'package:flutter/material.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/home/main_shell.dart';

void main() {
  runApp(const ShefaApp());
}

class ShefaApp extends StatelessWidget {
  const ShefaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shefa App',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      // Starting with Onboarding or Login for the flow
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const MainShell(),
      },
    );
  }
}
