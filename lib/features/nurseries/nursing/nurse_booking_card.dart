import 'package:flutter/material.dart';
import 'package:shefa/core/theme/color_app.dart';

import 'package:shefa/features/nurseries/nursing/nurse_booking_details_screen.dart';
import 'package:shefa/features/nurseries/nursing/nurse_booking_model.dart';

class NurseBookingCard extends StatelessWidget {
  final NurseBooking booking;

  const NurseBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: ColorApp.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: ColorApp.icons.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                booking.time,
                style: const TextStyle(
                  color: ColorApp.locationText,
                  fontSize: 10,
                ),
              ),
              const Text(
                'بيانات الحجز',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorApp.locationText,
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoRow('اسم المريض:', booking.patientName),
              _buildInfoRow('رقم التليفون:', booking.phone),
              _buildInfoRow('الحالة:', booking.status),
              _buildInfoRow('نوع الخدمة:', booking.serviceType),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NurseBookingDetailsScreen(booking: booking),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: ColorApp.buttonDetails,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    'تفاصيل الحجز',
                    style: TextStyle(
                      color: ColorApp.icons,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: ColorApp.icons,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: ColorApp.icons),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
