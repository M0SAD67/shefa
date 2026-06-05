import 'package:flutter/material.dart';
import '../../core/constants/assets_app.dart';
import '../../core/theme/color_app.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/medical_background_icons.dart';
import '../../l10n/app_localizations.dart';

class BookingRequestsScreen extends StatelessWidget {
  const BookingRequestsScreen({Key? key}) : super(key: key);

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
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        l10n.bookingRequests,
                        style: TextStyle(
                          fontSize: 16,
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
                      ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10,
                        ),
                        children: [
                          _buildBookingCard(
                            isDark: isDark,
                            title: 'مستشفي بنها الجامعي',
                            details: ['اسم المريض', 'رقم التليفون', 'الحاله'],
                            serviceType: 'عناية مركزة للكبار (ICU)',
                          ),
                          const SizedBox(height: 16),
                          _buildBookingCard(
                            isDark: isDark,
                            title: 'حجز طاقم طبي',
                            details: [
                              'اسم المريض',
                              'رقم التليفون',
                              'العنوان',
                              'الحاله',
                            ],
                            serviceType: 'رعاية كبار السن',
                          ),
                          const SizedBox(height: 16),
                          _buildBookingCard(
                            isDark: isDark,
                            title: 'مستشفي بنها الجامعي',
                            details: ['اسم الطفل', 'رقم التليفون'],
                            serviceType: '',
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard({
    required bool isDark,
    required String title,
    required List<String> details,
    required String serviceType,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 16.0,
        bottom: 20.0,
        left: 20.0,
        right: 20.0,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? ColorApp.icons.withOpacity(0.9)
            : Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isDark
              ? ColorApp.primary.withOpacity(0.3)
              : ColorApp.buttonDetails,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'بيانات الطلب',
              style: TextStyle(
                color: isDark ? Colors.white70 : ColorApp.locationText,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
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
          const SizedBox(height: 8),
          ...details.map(
            (detail) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                detail,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? ColorApp.secondary : ColorApp.primary,
                ),
              ),
            ),
          ),
          if (serviceType.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                'نوع الخدمة : $serviceType',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? ColorApp.secondary : ColorApp.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
