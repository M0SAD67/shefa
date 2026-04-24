import 'package:flutter/material.dart';

import 'package:shefa/core/theme/color_app.dart';
import 'package:shefa/features/hospital/nursery_request_model.dart';
import 'package:shefa/features/hospital/requestDetailScreen.dart';

class RequestCard extends StatelessWidget {
  final NurseryRequest request;

  const RequestCard({super.key, required this.request});

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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    request.time,
                    style: TextStyle(
                      color: ColorApp.locationText,
                      fontSize: 10,
                    ),
                  ),
                  Center(
                    child: Text(
                      'بيانات الطلب',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorApp.locationText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildLabelOnly('اسم الطفل'),
                  _buildLabelOnly('رقم التليفون'),
                  _buildLabelOnly('الحاله'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'نوع الخدمة:',
                        style: TextStyle(
                          color: ColorApp.icons,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        ' ${request.serviceType}',
                        style: TextStyle(
                          color: ColorApp.icons,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RequestDetailsScreen(request: request),
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
                        child: Text(
                          'تفاصيل الطلب',
                          style: TextStyle(
                            color: ColorApp.icons,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
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
    );
  }

  Widget _buildLabelOnly(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: ColorApp.icons,
          ),
        ),
      ),
    );
  }
}
