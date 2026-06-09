import 'package:flutter/material.dart';
import 'package:shefa/features/home/main_shell.dart';
import 'package:shefa/features/hospital/hospital_main_shell.dart';
import 'package:shefa/core/manager/app_state_manager.dart';

const Duration kLoginToMainTransition = Duration(milliseconds: 480);

/// After login: MainShell slides in from the "front" (start side in RTL, end in LTR)
/// with a light scale-up, paired with Login moving back via [ModalRoute.secondaryAnimation].
Route<void> loginSuccessToMainShellRoute() {
  return PageRouteBuilder<void>(
    settings: const RouteSettings(name: MainShell.routeName),
    opaque: false,
    barrierColor: Colors.transparent,
    transitionDuration: kLoginToMainTransition,
    reverseTransitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (context, animation, secondaryAnimation) {
      if (appStateManager.isHospital) {
        return const HospitalMainShell();
      }
      return const MainShell();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      final isRtl = Directionality.of(context) == TextDirection.rtl;
      // "Forward": enter from trailing edge in reading direction.
      final beginOffset = isRtl ? const Offset(-1, 0) : const Offset(1, 0);
      return FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(curved),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: beginOffset,
            end: Offset.zero,
          ).animate(curved),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1).animate(curved),
            child: child,
          ),
        ),
      );
    },
  );
}
