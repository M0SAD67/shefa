import 'package:flutter/material.dart';
import '../constants/assets_app.dart';
import '../theme/color_app.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
      decoration: BoxDecoration(
        color: isDark ? ColorApp.appDark : ColorApp.appLight,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              Hero(
                tag: 'app_logo',
                child: Image.asset(
                  AssetsApp.logo,
                  height: 45,
                ),
              ),

              // User Info
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '👋',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'علي عماد',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: isDark ? ColorApp.appLight : ColorApp.appDark,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'الفلل بنها القليوبيه',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: ColorApp.locationText.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Container(
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
                    child: const CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage(AssetsApp.userAvatar),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
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
    );
  }
}
