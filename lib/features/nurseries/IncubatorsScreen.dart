import 'package:flutter/material.dart';
import 'package:my_app/constants/assets_app.dart';
import 'package:my_app/theme/color_app.dart';

class IncubatorsScreen extends StatelessWidget {
  const IncubatorsScreen({Key? key}) : super(key: key);

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
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: ColorApp.buttonDetails,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: ColorApp.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorApp.secondary, width: 1.5), // الإطار الأخضر
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        AssetsApp.icOnboard1,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

               
                  const Text(
                    'حضانات أطفال',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ColorApp.primary,
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorApp.secondary, width: 1), // إطار أخضر
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'بحث عن منطقة , مستشفي , ....',
                                hintStyle: TextStyle(
                                  color: ColorApp.locationText.withOpacity(0.7),
                                  fontSize: 11,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(bottom: 12), // لضبط النص في المنتصف
                              ),
                            ),
                          ),
                          const Icon(Icons.search, color: ColorApp.locationText, size: 20),
                          const SizedBox(width: 8),
                        ],
                      ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    children: [
                      _buildHospitalCard(
                        hospitalName: 'مستشفي بنها الجامعي',
                        address: 'القليوبيه,بنها,اشاره',
                        normalIncubatorsText: '3 متاح',
                        normalAvailable: true,
                        nicuText: '1 متاح',
                        nicuAvailable: true,
                      ),
                      const SizedBox(height: 16),
                      _buildHospitalCard(
                        hospitalName: 'مستشفي بنها التعليمي',
                        address: 'القليوبيه,بنها,اهرام',
                        normalIncubatorsText: '4 متاح',
                        normalAvailable: true,
                        nicuText: 'غير متاح',
                        nicuAvailable: false,
                      ),
                      const SizedBox(height: 16),
                      _buildHospitalCard(
                        hospitalName: 'مستشفى أطفال بنها',
                        address: 'القليوبيه,بنها,اهرام',
                        normalIncubatorsText: '3 متاح',
                        normalAvailable: true,
                        nicuText: '4 متاح',
                        nicuAvailable: true,
                      ),
                      const SizedBox(height: 16),
                      _buildHospitalCard(
                        hospitalName: 'مستشفى أطفال بنها',
                        address: 'القليوبيه,بنها,اهرام',
                        normalIncubatorsText: '3 متاح',
                        normalAvailable: true,
                        nicuText: '4 متاح',
                        nicuAvailable: true,
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

  Widget _buildHospitalCard({
    required String hospitalName,
    required String address,
    required String normalIncubatorsText,
    required bool normalAvailable,
    required String nicuText,
    required bool nicuAvailable,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: ColorApp.buttonDetails,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorApp.appAmoled.withOpacity(0.04),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hospitalName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorApp.icons,
                ),
              ),
              const SizedBox(height: 6),

              Text(
                'العنوان : $address',
                style: const TextStyle(
                  fontSize: 13,
                  color: ColorApp.primary,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  const Text('🍼', style: TextStyle(fontSize: 14)), 
                  const SizedBox(width: 6),
                  const Text(
                    'حضانات أطفال: ',
                    style: TextStyle(fontSize: 13, color: ColorApp.locationText),
                  ),
                  Text(
                    normalIncubatorsText,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: normalAvailable ? ColorApp.secondary : ColorApp.red, // أخضر لو متاح، أحمر لو غير متاح
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  const Text('👶', style: TextStyle(fontSize: 14)), 
                  const SizedBox(width: 6),
                  const Text(
                    'حضانات (NICU) : ',
                    style: TextStyle(fontSize: 13, color: ColorApp.locationText),
                  ),
                  Text(
                    nicuText,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: nicuAvailable ? ColorApp.secondary : ColorApp.red, // أخضر لو متاح، أحمر لو غير متاح
                    ),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            bottom: 0,
            left: 0,
            child: InkWell(
              onTap: () {
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: ColorApp.buttonDetails,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: ColorApp.secondary.withOpacity(0.4), // الظل الأخضر الخفيف تحت الزر
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'التفاصيل',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: ColorApp.appDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}