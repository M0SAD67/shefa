import 'package:flutter/material.dart';
import 'package:shefa/core/theme/color_app.dart';
import 'package:shefa/core/widgets/hospital_header.dart';

import 'package:shefa/features/nurseries/nursing/nurse_booking_model.dart';

class NurseBookingDetailsScreen extends StatelessWidget {
  final NurseBooking booking;

  const NurseBookingDetailsScreen({super.key, required this.booking});

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
              _buildScreenHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: ColorApp.primary.withOpacity(0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorApp.icons.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              booking.time,
                              style: const TextStyle(
                                color: ColorApp.locationText,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const Center(
                            child: Text(
                              'بيانات  الطلب',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ColorApp.locationText,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow('اسم المريض:', booking.patientName),
                          _buildDetailRow('رقم التليفون:', booking.phone),
                          _buildDetailRow('الحالة:', booking.status),
                          _buildDetailRow('نوع الخدمة:', booking.serviceType),
                          const SizedBox(height: 20),
                          _buildActionButtons(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScreenHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorApp.primary.withOpacity(0.4),
          width: 1.5,
        ),
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
          Text(
            " طاقم طبي",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorApp.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: ColorApp.icons,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            ' $value',
            style: const TextStyle(
              color: ColorApp.icons,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: ColorApp.secondary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  'قبول الحجز',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
