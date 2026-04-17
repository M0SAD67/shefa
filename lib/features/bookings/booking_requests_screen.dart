import 'package:flutter/material.dart';
import '../../core/constants/assets_app.dart';
import '../../core/theme/color_app.dart';

class BookingRequestsScreen extends StatelessWidget {
  const BookingRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorApp.appLight,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 15,
                bottom: 15,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: ColorApp.appLight,
                border: Border(
                  bottom: BorderSide(
                    color: ColorApp.locationText.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorApp.appAmoled.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: ColorApp.primary.withOpacity(0.2),
                    backgroundImage: const AssetImage(AssetsApp.userAvatar),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'علي عماد',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: ColorApp.appDark,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text('👋', style: TextStyle(fontSize: 17)),
                          ],
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'الفلل بنها القليوبيه',
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorApp.locationText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(AssetsApp.logo, height: 50),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.arrow_back,
                    color: ColorApp.primary,
                    size: 20,
                  ),
                  const Text(
                    'طلبات الحجز',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorApp.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: ColorApp.buttonDetails,
                      borderRadius: BorderRadius.circular(4),
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
                        title: 'مستشفي بنها الجامعي',
                        details: ['اسم المريض', 'رقم التليفون', 'الحاله'],
                        serviceType: 'عناية مركزة للكبار (ICU)',
                      ),
                      const SizedBox(height: 16),
                      _buildBookingCard(
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
    );
  }

  Widget _buildBookingCard({
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
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: ColorApp.buttonDetails, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: ColorApp.appAmoled.withOpacity(0.04),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'بيانات الطلب',
              style: TextStyle(
                color: ColorApp.locationText,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorApp.icons,
            ),
          ),
          const SizedBox(height: 8),
          ...details.map(
            (detail) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                detail,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ColorApp.primary,
                ),
              ),
            ),
          ),
          if (serviceType.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                'نوع الخدمة : $serviceType',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorApp.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
