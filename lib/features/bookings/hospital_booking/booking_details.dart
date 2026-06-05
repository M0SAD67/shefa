import 'package:flutter/material.dart';
import 'package:my_app/constants/assets_app.dart';
import 'package:my_app/theme/color_app.dart';
import 'package:my_app/request_model.dart';
import 'package:my_app/request_model2.dart';
import 'dart:ui';

class BookingDetailsScreen extends StatelessWidget {
  final dynamic requestData; 

  const BookingDetailsScreen({Key? key, required this.requestData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    bool isNursery = requestData is NurseryRequest;
    String nameLabel = isNursery ? 'اسم الطفل' : 'اسم المريض';
    String nameValue = isNursery ? requestData.childName : requestData.patientName;
    String phoneValue = requestData.phone;
    String statusValue = requestData.status;
    String serviceTypeValue = requestData.serviceType;
    String timeValue = requestData.time;

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
                border: const Border(
                  bottom: BorderSide(
                    color: ColorApp.primary,
                    width: 2.0,
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
                  const Icon(Icons.notifications_none, color: ColorApp.primary, size: 28),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: ColorApp.secondary, width: 1.5),
                        ),
                        child: ClipOval(
                          child: Image.asset(AssetsApp.hospitalLogo, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'مستشفي بنها الجامعي',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorApp.appDark),
                          ),
                          Text(
                            'القليوبيه,بنها,الاشارة',
                            style: TextStyle(fontSize: 11, color: ColorApp.locationText),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Image.asset(AssetsApp.logo, height: 40),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context), 
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: ColorApp.buttonDetails,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.arrow_back, color: ColorApp.primary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'الحجوزات',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorApp.appAmoled),
                  ),
                  const Spacer(),
                  Container(
                    height: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ColorApp.secondary, width: 1),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.keyboard_arrow_down, color: ColorApp.secondary, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'الحجوزات المقبولة',
                          style: TextStyle(color: ColorApp.primary, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
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
                        child: Image.asset(AssetsApp.bgOnboardOpacity, fit: BoxFit.contain),
                      ),
                    ),
                  ),

                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Column(
                      children: [
                        
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(color: ColorApp.buttonDetails, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: ColorApp.appAmoled.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  timeValue,
                                  style: TextStyle(fontSize: 10, color: ColorApp.locationText.withOpacity(0.6)),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'بيانات الطلب',
                                style: TextStyle(color: ColorApp.locationText, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 24),
                              
                              Text('$nameLabel : $nameValue', style: const TextStyle(fontSize: 16, color: ColorApp.primary, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Text('رقم التليفون : $phoneValue', style: const TextStyle(fontSize: 16, color: ColorApp.primary, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              const Text('الحاله :', style: TextStyle(fontSize: 16, color: ColorApp.primary, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(statusValue, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: ColorApp.primary, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 16),
                              Text('نوع الخدمة : $serviceTypeValue', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorApp.primary)),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 20),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              _showDeleteDialog(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC60000), 
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'حذف الطلب',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
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


  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0.4), 
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0), 
            child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.white,
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'هل انت متأكد ؟',
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold, 
                        color: ColorApp.icons, 
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                           
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD30000),
                              borderRadius: BorderRadius.circular(20), 
                            ),
                            child: const Text(
                              'تأكيد الحذف', 
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),     
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.withOpacity(0.3), 
                              borderRadius: BorderRadius.circular(20), 
                            ),
                            child: const Text(
                              'رجوع', 
                              style: TextStyle(color: Color(0xFF1E2B4D), fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}