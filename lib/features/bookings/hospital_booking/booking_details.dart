import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/assets_app.dart';
import '../../../core/theme/color_app.dart';
import '../../../core/widgets/hospital_header.dart';
import '../../../l10n/app_localizations.dart';
import '../../hospital/nursery_request_model.dart';

class BookingDetailsScreen extends StatelessWidget {
  final dynamic requestData;

  const BookingDetailsScreen({Key? key, required this.requestData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    bool isNursery = requestData is NurseryRequest;
    String nameLabel = isNursery ? l10n.childNameLabel : l10n.patientNameLabel;
    String nameValue = isNursery
        ? requestData.childName
        : requestData.patientName;
    String phoneValue = requestData.phone;
    String statusValue = requestData.status;
    String serviceTypeValue = requestData.serviceType;
    String timeValue = requestData.time;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? ColorApp.appDark : ColorApp.appLight,
        body: Column(
          children: [
            // Standard Hospital Header
            const HospitalHeader(),

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
                        color: isDark
                            ? ColorApp.appLight.withValues(alpha: 0.1)
                            : ColorApp.buttonDetails,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: isDark ? Colors.white : ColorApp.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.bookingsTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : ColorApp.appAmoled,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? ColorApp.icons : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ColorApp.secondary, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: ColorApp.secondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.bookingDetailsTitle,
                          style: TextStyle(
                            color: isDark ? Colors.white : ColorApp.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
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
                        opacity: isDark ? 0.05 : 0.15,
                        child: Image.asset(
                          AssetsApp.bgOnboardOpacity,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24.0),
                          decoration: BoxDecoration(
                            color: isDark
                                ? ColorApp.icons.withValues(alpha: 0.9)
                                : Colors.white.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: isDark
                                  ? Colors.grey[800]!
                                  : ColorApp.buttonDetails,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  timeValue,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark
                                        ? Colors.grey[400]
                                        : ColorApp.locationText.withValues(
                                            alpha: 0.8,
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: Text(
                                  l10n.detailedRequestData,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white
                                        : ColorApp.locationText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Divider(
                                color: isDark
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                              ),
                              const SizedBox(height: 10),

                              _buildDetailRow(nameLabel, nameValue, isDark),
                              const SizedBox(height: 12),
                              _buildDetailRow(
                                l10n.phoneLabelText,
                                phoneValue,
                                isDark,
                              ),
                              const SizedBox(height: 12),
                              _buildDetailRow(
                                l10n.statusLabel,
                                statusValue,
                                isDark,
                              ),
                              const SizedBox(height: 12),
                              _buildDetailRow(
                                l10n.serviceTypeLabel,
                                serviceTypeValue,
                                isDark,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              _showDeleteDialog(context, isDark, l10n);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: ColorApp.error,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorApp.error.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                l10n.deleteRequestButton,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark
                ? Colors.grey[400]
                : ColorApp.primary.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isDark
                ? ColorApp.primary.withValues(alpha: 0.2)
                : const Color(0xFFF0F4F8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      barrierColor: isDark
          ? Colors.black.withValues(alpha: 0.6)
          : Colors.white.withValues(alpha: 0.4),
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: isDark ? ColorApp.icons : Colors.white,
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.areYouSureDialogTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : ColorApp.icons,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context); // Close dialog
                            Navigator.pop(context); // Pop back to list screen
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: ColorApp.error,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              l10n.confirmDeleteButton,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : Colors.blueGrey.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              l10n.backButtonText,
                              style: TextStyle(
                                color: isDark ? Colors.white : ColorApp.icons,
                                fontWeight: FontWeight.bold,
                              ),
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
