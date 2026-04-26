import 'package:flutter/material.dart';
import 'package:shefa/core/theme/color_app.dart';
import 'package:shefa/core/widgets/hospital_header.dart';
import 'package:shefa/features/hospital/nursery_request_model.dart';
import 'package:shefa/features/hospital/requestCard.dart';

class NurseryRequestsScreen extends StatelessWidget {
  NurseryRequestsScreen({super.key});

  final List<NurseryRequest> requests = [
    NurseryRequest(
      childName: 'أحمد محمد',
      phone: '0100000000',
      status: '********************************************',
      serviceType: 'حضانات أطفال',
      time: '5:54 PM - 10 Jan 2026',
    ),
    NurseryRequest(
      childName: 'سارة علي',
      phone: '0111111111',
      status: '******************************************',
      serviceType: ' حضانات أطفال',
      time: '3:20 PM - 11 Jan 2026',
    ),
    NurseryRequest(
      childName: 'محمود حسن',
      phone: '0122222222',
      status: '*******************************************',
      serviceType: 'حضانات أطفال ',
      time: '1:10 PM - 12 Jan 2026',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/background-reduce-opacity.png',
            ),
          ),
          Column(
            children: [
              const HospitalHeader(),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: ColorApp.primary.withOpacity(0.1),
                        shape: BoxShape.rectangle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: ColorApp.primary,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ColorApp.primary.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/onboard/onboard-1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'طلبات حجز حضانات الأطفال',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorApp.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    return RequestCard(request: requests[index]);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
