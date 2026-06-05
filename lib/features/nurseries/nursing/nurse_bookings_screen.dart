import 'package:flutter/material.dart';
import 'package:shefa/core/theme/color_app.dart';
import 'package:shefa/core/widgets/hospital_header.dart';

import 'package:shefa/features/nurseries/nursing/nurse_booking_card.dart';
import 'package:shefa/features/nurseries/nursing/nurse_booking_model.dart';

class NurseBookingsScreen extends StatelessWidget {
  NurseBookingsScreen({super.key});

  final List<NurseBooking> bookings = [
    const NurseBooking(
      patientName: 'إبراهيم حسن',
      phone: '0155555555',
      status: '************************',
      serviceType: 'رعاية كبار السن',
      time: '5:54 PM - 24 Apr 2026',
    ),
    const NurseBooking(
      patientName: 'أحمد محمد',
      phone: '01023456789',
      status: '************************',
      serviceType: 'رعاية كبار السن',
      time: '8:00 PM - 24 Apr 2026',
    ),
    const NurseBooking(
      patientName: 'وليد سباعي',
      phone: '0102545481',
      status: '************************',
      serviceType: 'رعاية كبار السن',
      time: '8:00 PM - 24 Apr 2026',
    ),
    const NurseBooking(
      patientName: ' محمد علي',
      phone: '010545486789',
      status: '************************',
      serviceType: 'رعاية كبار السن',
      time: '8:00 PM - 24 Apr 2026',
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
              _buildCustomAppBar(context),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    return NurseBookingCard(booking: bookings[index]);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                'assets/images/onboard/onboard-3.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            ' طاقم طبي',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorApp.primary,
            ),
          ),
        ],
      ),
    );
  }
}
