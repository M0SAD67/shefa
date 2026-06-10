import 'package:flutter/material.dart';
import 'package:shefa/core/theme/color_app.dart';
import 'package:shefa/l10n/app_localizations.dart';
import 'package:shefa/features/hospital/icu_request_details_screen.dart';
import 'package:shefa/features/hospital/icu_request_model.dart';

class IcuRequestCard extends StatelessWidget {
  final IcuRequest request;

  const IcuRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

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
                      l10n.requestDataTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorApp.locationText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildLabelOnly(l10n.patientNameLabel, isAr),
                  _buildLabelOnly(l10n.phoneLabelText, isAr),
                  _buildLabelOnly(l10n.conditionLabel, isAr),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.serviceTypeLabel}:',
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
                                IcuRequestDetailsScreen(request: request),
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
                          l10n.requestDetailsLabel,
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

  Widget _buildLabelOnly(String title, bool isAr) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Align(
        alignment: isAr ? Alignment.centerRight : Alignment.centerLeft,
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
