import 'package:flutter/material.dart';
import '../../core/constants/assets_app.dart';
import '../../core/theme/color_app.dart';
import '../../core/widgets/app_header.dart';

class BookingConfirmationScreen extends StatelessWidget {
  static const String routeName = 'BookingConfirmationScreen';
  BookingConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? ColorApp.appDark : ColorApp.appLight,
        body: Column(
          children: [
            const AppHeader(),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: ColorApp.buttonDetails,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: ColorApp.primary,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorApp.secondary, width: 1.5),
                      color: isDark ? ColorApp.appAmoled : Colors.white,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        AssetsApp.icOnboard1,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  const Text(
                    'حضانات أطفال',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: ColorApp.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: 0.15,
                        child: Image.asset(
                          AssetsApp.bgOnboardOpacity,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        _buildRequestDataCard(context),

                        const SizedBox(height: 40),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: ColorApp.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: ColorApp.icons,
                            size: 40,
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          'تم إرسال طلب الحجز',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: ColorApp.secondary,
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestDataCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: isDark
            ? ColorApp.appDark.withOpacity(0.8)
            : Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: ColorApp.buttonDetails, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: ColorApp.appAmoled.withOpacity(0.04),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'بيانات الطلب',
            style: TextStyle(
              color: ColorApp.locationText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'مستشفي بنها الجامعي',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : ColorApp.icons,
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'اسم الطفل',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorApp.secondary,
            ),
          ),
          const SizedBox(height: 6),

          const Text(
            'رقم تليفون',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorApp.secondary,
            ),
          ),
          const SizedBox(height: 6),

          const Text(
            'الحاله',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorApp.secondary,
            ),
          ),
          const SizedBox(height: 6),

          const Text(
            'نوع الخدمة : حضانات اطفال',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorApp.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
