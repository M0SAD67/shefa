import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/cache/cache_helper.dart';
import 'core/manager/app_state_manager.dart';
import 'core/theme/color_app.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/home/main_shell.dart';
import 'features/nurseries/nurseries_screen.dart';
import 'features/icu/icu_screen.dart';
import 'features/medical_staff/medical_staff_screen.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  appStateManager.init();
  runApp(const ShefaApp());
}

class ShefaApp extends StatelessWidget {
  const ShefaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appStateManager,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: appStateManager.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          themeMode: appStateManager.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: ColorApp.primary,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: ColorApp.appDark,
            brightness: Brightness.dark,
          ),
          routes: {
            OnboardingScreen.routeName: (context) => const OnboardingScreen(),
            LoginScreen.routeName: (context) => const LoginScreen(),
            SignupScreen.routeName: (context) => const SignupScreen(),
            MainShell.routeName: (context) => const MainShell(),
            NurseriesScreen.routeName: (context) => const NurseriesScreen(),
            IcuScreen.routeName: (context) => const IcuScreen(),
            MedicalStaffScreen.routeName: (context) => const MedicalStaffScreen(),
          },
          home: const MainShell(),
        );
      },
    );
  }
}
