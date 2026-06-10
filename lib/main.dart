import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/cache/cache_helper.dart';
import 'core/manager/app_state_manager.dart';
import 'core/theme/color_app.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/home/main_shell.dart';
import 'features/hospital/hospital_main_shell.dart';
import 'features/nurseries/nurseries_screen.dart';
import 'features/nurseries/IncubatorsScreen.dart';
import 'features/nurseries/IncubatorsDetailsScreen.dart';
import 'features/nurseries/Incubatorsbook.dart';
import 'features/bookings/bookconfirm.dart';
import 'features/icu/icu_screen.dart';
import 'features/medical_staff/medical_staff_screen.dart';
import 'l10n/app_localizations.dart';

/// Global navigator key so interceptors can navigate without context.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
          navigatorKey: navigatorKey,
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
            IncubatorsScreen.routeName: (context) => const IncubatorsScreen(),
            IncubatorDetailsScreen.routeName: (context) =>
                IncubatorDetailsScreen(),
            BookingScreen.routeName: (context) => const BookingScreen(),
            BookingConfirmationScreen.routeName: (context) =>
                BookingConfirmationScreen(),
            IcuScreen.routeName: (context) => const IcuScreen(),
            MedicalStaffScreen.routeName: (context) =>
                const MedicalStaffScreen(),
          },
          home: const AppStartScreen(),
        );
      },
    );
  }
}

class AppStartScreen extends StatelessWidget {
  const AppStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final token = CacheHelper.getData(key: 'token');
    if (token != null) {
      if (appStateManager.isHospital) {
        return const HospitalMainShell();
      }
      return const MainShell();
    }
    return const OnboardingScreen();
  }
}
