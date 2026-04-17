import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/assets_app.dart';
import '../../core/theme/color_app.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/medical_background_icons.dart';
import '../../l10n/app_localizations.dart';
import '../icu/icu_screen.dart';
import '../nurseries/nurseries_screen.dart';
import '../nurseries/IncubatorsScreen.dart';
import '../bookings/bookings_screen.dart';
import '../medical_staff/medical_staff_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'HomeScreen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? ColorApp.appDark : ColorApp.appLight,
      body: Stack(
        children: [
          // Pattern Background
          const Positioned.fill(child: MedicalIconsBackground()),

          SafeArea(
            child: Column(
              children: [
                const AppHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _CategoryCircle(
                            title: l10n.nurseries,
                            imagePath: AssetsApp.icOnboard1,
                            onTap: () => Navigator.pushNamed(
                              context,
                              IncubatorsScreen.routeName,
                            ),
                          ),
                          const SizedBox(height: 35),
                          _CategoryCircle(
                            title: l10n.icu,
                            imagePath: AssetsApp.icOnboard2,
                            onTap: () => Navigator.pushNamed(
                              context,
                              IcuScreen.routeName,
                            ),
                          ),
                          const SizedBox(height: 35),
                          _CategoryCircle(
                            title: l10n.medicalStaff,
                            imagePath: AssetsApp.icOnboard3,
                            onTap: () => Navigator.pushNamed(
                              context,
                              MedicalStaffScreen.routeName,
                            ),
                          ),
                          const SizedBox(height: 35),
                          _CategoryCircle(
                            title: l10n.bookings,
                            imagePath: AssetsApp.logo, // Temporary using logo until a specific icon is found
                            onTap: () => Navigator.pushNamed(
                              context,
                              BookingsScreen.routeName,
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCircle extends StatefulWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const _CategoryCircle({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  State<_CategoryCircle> createState() => _CategoryCircleState();
}

class _CategoryCircleState extends State<_CategoryCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer Glow/Border
                Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorApp.secondary.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                ),
                // Inner Border (Blue Gradient Look)
                Container(
                  width: 155,
                  height: 155,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorApp.primary.withOpacity(0.9),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorApp.primary.withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: ClipOval(
                      child: Image.asset(widget.imagePath, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).brightness == Brightness.dark
                    ? ColorApp.appLight
                    : ColorApp.icons,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
