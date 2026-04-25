import 'package:flutter/material.dart';
import 'package:my_app/booking_details.dart';
import 'package:my_app/constants/assets_app.dart';
import 'package:my_app/theme/color_app.dart';
import 'package:my_app/request_model.dart'; 
import 'package:my_app/request_model2.dart';  

class HospitalBookingsScreen extends StatefulWidget {
  const HospitalBookingsScreen({Key? key}) : super(key: key);

  @override
  State<HospitalBookingsScreen> createState() => _HospitalBookingsScreenState();
}

class _HospitalBookingsScreenState extends State<HospitalBookingsScreen> {
  String _selectedFilter = 'الحجوزات المقبولة';

  final List<dynamic> _acceptedRequests = [
    NurseryRequest(
      childName: 'أحمد محمود',
      phone: '0123456789',
      status: '***************************',
      serviceType: 'حضانات اطفال',
      time: '5:54 PM - 10 Jan 2026',
    ),
    IcuRequest(
      patientName: 'سيد علي',
      phone: '0111111111',
      status: '***************************',
      serviceType: 'عناية مركزة للكبار (ICU)',
      time: '6:00 PM - 10 Jan 2026',
    ),
  ];

  final List<dynamic> _rejectedRequests = [
    IcuRequest(
      patientName: 'محمد إبراهيم',
      phone: '0100000000',
      status: 'لا توجد أسرة خالية حالياً',
      serviceType: 'عناية مركزة للكبار (ICU)',
      time: '9:00 AM - 11 Jan 2026',
    ),
    NurseryRequest(
      childName: 'طفل غير محدد (مرفوض)',
      phone: '0122222222',
      status: 'الحالة لا تستدعي حضانة',
      serviceType: 'حضانات اطفال',
      time: '10:30 AM - 11 Jan 2026',
    ),
    IcuRequest(
      patientName: 'محمد إبراهيم (مرفوض)',
      phone: '01000',
      status: 'لا توجد أسرة خالية حالياً',
      serviceType: 'حضانات اطفال',
      time: '9:00 AM - 11 Jan 2026',
    ),

  ];

  @override
  Widget build(BuildContext context) {
    List<dynamic> displayedRequests = _selectedFilter == 'الحجوزات المقبولة' 
        ? _acceptedRequests 
        : _rejectedRequests;

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
                  bottom: BorderSide(color: ColorApp.primary, width: 2.0),
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
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: ColorApp.buttonDetails,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.arrow_back, color: ColorApp.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'الحجوزات',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorApp.textLight),
                  ),
                  const Spacer(),
                 
                  Container(
                    height: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ColorApp.secondary, width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedFilter,
                        icon: const Icon(Icons.keyboard_arrow_down, color: ColorApp.secondary, size: 20),
                        dropdownColor: Colors.white, 
                        borderRadius: BorderRadius.circular(12), 
                        style: const TextStyle(
                          color: ColorApp.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedFilter = newValue!;
                          });
                        },
                        items: <String>['الحجوزات المقبولة', 'الحجوزات المرفوضة']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
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
                        child: Image.asset(AssetsApp.bgOnboardOpacity, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  
                
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    itemCount: displayedRequests.length,
                    itemBuilder: (context, index) {
                      final request = displayedRequests[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildBookingCard(request),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(dynamic request) {
    bool isNursery = request is NurseryRequest;
    String nameLabel = isNursery ? 'اسم الطفل' : 'اسم المريض';
    
    String nameValue = isNursery ? request.childName : request.patientName;
    String phoneValue = request.phone;
    String statusValue = request.status;
    String serviceTypeValue = request.serviceType;
    String timeValue = request.time;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: ColorApp.buttonDetails, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: ColorApp.appAmoled.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              timeValue,
              style: TextStyle(fontSize: 10, color: ColorApp.locationText.withOpacity(0.6)),
            ),
          ),
          
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
          const SizedBox(height: 16),

          Text(nameLabel, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: ColorApp.primary)),
          const SizedBox(height: 6),
          const Text('رقم التليفون', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: ColorApp.primary)),
          const SizedBox(height: 6),
          const Text('الحاله', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: ColorApp.primary)),
          const SizedBox(height: 6),
          Text('نوع الخدمة : $serviceTypeValue', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: ColorApp.primary)),
          
          const SizedBox(height: 20),
          
          Center(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailsScreen(requestData: request),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: ColorApp.buttonDetails,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: ColorApp.secondary.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'عرض التفاصيل',
                  style: TextStyle(
                    fontSize: 11, 
                    fontWeight: FontWeight.bold, 
                    color: ColorApp.appDark
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