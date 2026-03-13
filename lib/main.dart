import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shefa/core/constants/routes_app.dart';
import 'package:shefa/features/home/home_screen.dart';
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
      supportedLocales: [
        Locale('ar', 'EG'), // العربية
        Locale('en', 'US'), // الإنجليزية
      ],
      // تحديد اللغة الحالية للعربية
      locale: const Locale('ar', 'EG'),
      // إضافة الـ Delegates (مهمة جداً عشان فلاتر يفهم الاتجاهات)
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      // Starting with Onboarding or Login for the flow
      // initialRoute: RoutesApp.onboarding,
      routes: {
        //OnboardingScreen.routeName: (context) => const OnboardingScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        //SignupScreen.routeName: (context) => const SignupScreen(),
        //MainShell.routeName: (context) => const MainShell(),
      },
      home: const MainShell(),
    );
  }
}
