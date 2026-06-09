import 'package:flutter/material.dart';
import '../../core/constants/assets_app.dart';
import '../../core/theme/color_app.dart';
import '../../core/widgets/hospital_header.dart';
import '../../l10n/app_localizations.dart';
import 'bookingChildrensNurseries.dart';
import 'icu_requests_screen.dart';

class HospitalBookingRequestsSelectScreen extends StatelessWidget {
  const HospitalBookingRequestsSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? ColorApp.appDark : ColorApp.appLight,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AssetsApp.bgOnboardOpacity,
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.6),
            ),
          ),
          Column(
            children: [
              const HospitalHeader(),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Nursery Requests Circle Card
                        _buildImageButton(
                          context,
                          isDark: isDark,
                          title: l10n.nurseryBookingRequests,
                          imagePath: AssetsApp.icOnboard1,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NurseryRequestsScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 35),

                        // ICU Requests Circle Card
                        _buildImageButton(
                          context,
                          isDark: isDark,
                          title: l10n.icuBookingRequests,
                          imagePath: AssetsApp.icOnboard2,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IcuRequestsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageButton(
    BuildContext context, {
    required bool isDark,
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 160,
            height: 160,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorApp.secondary.withValues(alpha: 0.6),
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(child: Image.asset(imagePath, fit: BoxFit.contain)),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : ColorApp.icons,
            ),
          ),
        ],
      ),
    );
  }
}
