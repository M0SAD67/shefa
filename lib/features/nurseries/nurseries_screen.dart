import 'package:flutter/material.dart';
import '../../core/theme/color_app.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/medical_background_icons.dart';
import '../../l10n/app_localizations.dart';

class NurseriesScreen extends StatelessWidget {
  static const String routeName = 'NurseriesScreen';
  const NurseriesScreen({super.key});

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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 100),
                          Icon(
                            Icons.child_care,
                            size: 100,
                            color: ColorApp.primary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            l10n.nurseries,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark ? ColorApp.appLight : ColorApp.appDark,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "هذا القسم قيد التطوير حالياً",
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
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
