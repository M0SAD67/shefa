import 'package:flutter/material.dart';

import 'package:shefa/core/theme/color_app.dart';
import 'package:shefa/l10n/app_localizations.dart';
import 'package:shefa/features/hospital/nursery_request_model.dart';
import 'package:shefa/features/hospital/requestDetailScreen.dart';

class RequestCard extends StatelessWidget {
  final NurseryRequest request;

  const RequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? ColorApp.icons.withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isDark
              ? ColorApp.primary.withValues(alpha: 0.3)
              : ColorApp.primary.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                        color: isDark ? Colors.white : ColorApp.locationText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildValueRow(
                    l10n.childNameLabel,
                    request.childName,
                    isDark,
                  ),
                  _buildValueRow(l10n.phoneLabelText, request.phone, isDark),
                  if (request.condition.isNotEmpty)
                    _buildValueRow(
                      l10n.conditionLabel,
                      request.condition,
                      isDark,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.serviceTypeLabel}:',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : ColorApp.icons,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        ' ${request.serviceType}',
                        style: TextStyle(
                          color: ColorApp.primary,
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

  Widget _buildValueRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: isDark ? Colors.white70 : ColorApp.icons,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: ColorApp.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
