import 'package:flutter/material.dart';
import '../constants/assets_app.dart';
import '../theme/color_app.dart';

class HospitalHeader extends StatelessWidget {
  const HospitalHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 12),
      decoration: BoxDecoration(
        color: isDark ? ColorApp.appDark : ColorApp.appLight,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF0D47A1).withOpacity(0.2),
            width: 1.2,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                // 1. أيقونة التنبيهات (جهة اليسار)
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset('assets/icon/bell.png', height: 28),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),

                // مسافة مرنة تدفع المحتوى للمنتصف
                const Spacer(),

                // 2. الجزء الأوسط: اللوجو + النصوص (متلاصقين)
                Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Image.asset(
                      AssetsApp.hospitalLogo,
                      height: 55, // حجم مناسب عشان مياخدش مساحة رأسية كبيرة
                    ),
                    SizedBox(width: 8),
                    Column(
                      // محاذاة لليمين
                      children: [
                        Text(
                          'مستشفى بنها الجامعي',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: isDark
                                ? ColorApp.textDark
                                : ColorApp.textLight,
                          ),
                        ),
                        Text(
                          'القليوبية، بنها، الإشارة',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: ColorApp.locationText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const Spacer(),

                // 3. شعار "شفاء" (جهة اليمين)
                Hero(
                  tag: 'shifa_logo',
                  child: Image.asset(AssetsApp.logo, height: 55),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // الـ Divider الاحترافي
            Container(
              height: 1.2,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorApp.primary.withOpacity(0.0),
                    ColorApp.primary.withOpacity(0.4),
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
}
