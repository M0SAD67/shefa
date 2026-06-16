import 'dart:io';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:flutter/material.dart';
import '../constants/assets_app.dart';
import '../manager/app_state_manager.dart';
import '../theme/color_app.dart';
import '../../features/profile/profile_screen.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (Platform.isIOS) {
      return _buildIOSHeader(context, isDark);
    }

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 15),
      decoration: BoxDecoration(
        color: isDark ? ColorApp.appDark : ColorApp.appLight,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // User Info (Android / Generic)
                ListenableBuilder(
                  listenable: appStateManager,
                  builder: (context, _) {
                    final String patientName =
                        appStateManager.userName.trim().isNotEmpty
                        ? appStateManager.userName
                        : 'أميره محسن';
                    final String patientAddress =
                        appStateManager.userAddress.trim().isNotEmpty
                        ? appStateManager.userAddress
                        : 'Giza - Dokki, Street 5';

                    // تحديد هل المستخدم أنثى (سواء من الـ state أو كقيمة افتراضية لـ أميرة)
                    final bool isFemaleUser =
                        appStateManager.isFemale || patientName == "أميره محسن";

                    return Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ColorApp.primary.withOpacity(0.2),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: appStateManager.profileImage.isNotEmpty
                                ? Image.network(
                                    appStateManager.profileImage,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        isFemaleUser
                                            ? AssetsApp.userAvatarWomen
                                            : AssetsApp.userAvatarMan,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    isFemaleUser
                                        ? AssetsApp.userAvatarWomen
                                        : AssetsApp.userAvatarMan,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  patientName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: isDark
                                        ? ColorApp.appLight
                                        : ColorApp.appDark,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '👋',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            Text(
                              patientAddress,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: ColorApp.locationText.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),

                // Logo
                Hero(
                  tag: 'app_logo',
                  child: Image.asset(AssetsApp.logo, height: 45),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Subtle Divider
            Container(
              height: 1.5,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorApp.primary.withOpacity(0.0),
                    ColorApp.primary.withOpacity(0.5),
                    ColorApp.primary.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIOSHeader(BuildContext context, bool isDark) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ── Profile (iOS) ───────────────────────────────────────────
            ListenableBuilder(
              listenable: appStateManager,
              builder: (context, _) {
                final String patientName =
                    appStateManager.userName.trim().isNotEmpty
                    ? appStateManager.userName
                    : 'أميره محسن'; // تغيير القيمة الافتراضية من 'مريض' إلى الاسم المطلوب

                // تشييك الأيقونة لتكون أنثى بناءً على الـ state أو الاسم الافتراضي
                final bool isFemaleUser =
                    appStateManager.isFemale || patientName == "أميره محسن";

                final String avatarAsset = isFemaleUser
                    ? AssetsApp.userAvatarWomen
                    : AssetsApp.userAvatarMan;

                return CNButton(
                  imageAsset: CNImageAsset(avatarAsset, size: 28),
                  label: '$patientName 👋',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  ),
                  config: const CNButtonConfig(
                    style: CNButtonStyle.glass,
                    imagePlacement: CNImagePlacement.trailing,
                    imagePadding: 6,
                  ),
                );
              },
            ),

            // ── Logo ──────────────────────────────────────────────────
            CNButton.icon(
              imageAsset: const CNImageAsset(AssetsApp.logo),
              onPressed: () {},
              config: const CNButtonConfig(
                style: CNButtonStyle.glass,
                padding: EdgeInsets.all(6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
