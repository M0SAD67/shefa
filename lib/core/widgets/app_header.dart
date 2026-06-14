import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
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
                // User Info
                ListenableBuilder(
                  listenable: appStateManager,
                  builder: (context, _) {
                    final String patientName =
                        appStateManager.userName.isNotEmpty
                        ? appStateManager.userName
                        : 'مريض';
                    final String patientAddress =
                        appStateManager.userAddress.isNotEmpty
                        ? appStateManager.userAddress
                        : 'موقع غير محدد';

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
                                        appStateManager.isFemale
                                            ? AssetsApp.userAvatarWomen
                                            : AssetsApp.userAvatarMan,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    appStateManager.isFemale
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
    return ClipRect(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // User Info
              ListenableBuilder(
                listenable: appStateManager,
                builder: (context, _) {
                  final String patientName = appStateManager.userName.isNotEmpty
                      ? appStateManager.userName
                      : 'مريض';
                  final String patientAddress =
                      appStateManager.userAddress.isNotEmpty
                      ? appStateManager.userAddress
                      : 'موقع غير محدد';

                  return CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.06),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: appStateManager.profileImage.isNotEmpty
                                  ? Image.network(
                                      appStateManager.profileImage,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Image.asset(
                                              appStateManager.isFemale
                                                  ? AssetsApp.userAvatarWomen
                                                  : AssetsApp.userAvatarMan,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                    )
                                  : Image.asset(
                                      appStateManager.isFemale
                                          ? AssetsApp.userAvatarWomen
                                          : AssetsApp.userAvatarMan,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    patientName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? ColorApp.appLight
                                          : ColorApp.appDark,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    '👋',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Text(
                                patientAddress,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: ColorApp.locationText.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Logo
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.04),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.06),
                      width: 0.5,
                    ),
                  ),
                  child: Hero(
                    tag: 'app_logo',
                    child: Image.asset(AssetsApp.logo, height: 26),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
