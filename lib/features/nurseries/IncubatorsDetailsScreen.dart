import 'package:flutter/material.dart';
import '../../core/constants/assets_app.dart';
import '../../core/theme/color_app.dart';
import '../../core/widgets/app_header.dart';
import 'Incubatorsbook.dart';

class IncubatorDetailsScreen extends StatelessWidget {
  static const String routeName = 'IncubatorDetailsScreen';
  IncubatorDetailsScreen({Key? key}) : super(key: key);

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
                        _buildDetailsCard(context),

                        const SizedBox(height: 30),

                        _buildBookButton(context),

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

  Widget _buildDetailsCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'مستشفي بنها الجامعي',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : ColorApp.icons,
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'عنوان المستشفي : القليوبيه,بنها,اشاره',
            style: TextStyle(fontSize: 14, color: ColorApp.primary),
          ),
          const SizedBox(height: 12),

          const Text(
            'رقم تليفون : ',
            style: TextStyle(fontSize: 14, color: ColorApp.primary),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              const Text('🍼', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              const Text(
                'حضانات أطفال: ',
                style: TextStyle(fontSize: 15, color: ColorApp.primary),
              ),
              const Text(
                '3 متاح',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: ColorApp.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'لحالات:',
            style: TextStyle(fontSize: 14, color: ColorApp.primary),
          ),
          const SizedBox(height: 4),
          _buildBulletPoint('الصفراء'),
          _buildBulletPoint('وزن قليل'),
          _buildBulletPoint('متابعة بعد الولادة'),
          _buildBulletPoint('احتياج أكسجين'),

          const SizedBox(height: 20),

          Row(
            children: [
              const Text('👶', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              const Text(
                'العناية لحديثي الولادة (NICU) : ',
                style: TextStyle(fontSize: 15, color: ColorApp.primary),
              ),
              const Text(
                '1 متاح',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: ColorApp.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'لحالات:',
            style: TextStyle(fontSize: 14, color: ColorApp.primary),
          ),
          const SizedBox(height: 4),
          _buildBulletPoint('الولادة المبكرة'),
          _buildBulletPoint('مشاكل تنفس شديدة'),
          _buildBulletPoint('وزن منخفض جدًا'),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 6.0,
        right: 16.0,
      ), // إزاحة لليمين (Indentation)
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorApp.primary,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: ColorApp.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, BookingScreen.routeName);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 180,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: ColorApp.buttonDetails,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: ColorApp.secondary.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'حجز',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorApp.appAmoled,
            ),
          ),
        ),
      ),
    );
  }
}
