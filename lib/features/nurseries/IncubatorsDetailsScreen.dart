import 'package:flutter/material.dart';

import '../../core/constants/assets_app.dart';
import '../../core/theme/color_app.dart';
import '../../core/widgets/app_header.dart';
import '../../l10n/app_localizations.dart';
import 'Incubatorsbook.dart';
import 'patient_service_model.dart';

class IncubatorDetailsScreen extends StatelessWidget {
  static const String routeName = 'IncubatorDetailsScreen';
  const IncubatorDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service =
        ModalRoute.of(context)?.settings.arguments as PatientService?;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? ColorApp.appDark : ColorApp.appLight,
        body: Column(
          children: [
            const AppHeader(),
            const SizedBox(height: 15),
            _buildHeader(context, l10n, isDark),
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
                  if (service == null)
                    Center(child: Text(l10n.noServiceData, style: const TextStyle(color: ColorApp.primary)))
                  else
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Column(
                        children: [
                          _buildDetailsCard(context, service, l10n),
                          const SizedBox(height: 30),
                          _buildBookButton(context, service, l10n),
                          const SizedBox(height: 20),
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

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: ColorApp.buttonDetails, borderRadius: BorderRadius.circular(6)),
              child: const Icon(Icons.arrow_back, color: ColorApp.primary, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 45, height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ColorApp.secondary, width: 1.5),
              color: isDark ? ColorApp.appAmoled : Colors.white,
            ),
            child: ClipOval(child: Image.asset(AssetsApp.icOnboard1, fit: BoxFit.cover)),
          ),
          const SizedBox(width: 12),
          Text(l10n.nurseries, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: ColorApp.primary)),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, PatientService service, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isDark ? ColorApp.appDark.withOpacity(0.8) : Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: ColorApp.buttonDetails, width: 1.5),
        boxShadow: [BoxShadow(color: ColorApp.appAmoled.withOpacity(0.04), blurRadius: 10, spreadRadius: 2, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text(service.hospitalName, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : ColorApp.icons))),
          const SizedBox(height: 16),
          Text(l10n.hospitalAddressLabel(service.hospitalAddress.isEmpty ? l10n.notSpecified : service.hospitalAddress), style: const TextStyle(fontSize: 14, color: ColorApp.primary)),
          const SizedBox(height: 12),
          Text(l10n.hospitalPhoneLabel(service.hospitalPhone.isEmpty ? l10n.unavailable : service.hospitalPhone), style: const TextStyle(fontSize: 14, color: ColorApp.primary)),
          const SizedBox(height: 16),
          Row(children: [
            const Icon(Icons.child_care, color: ColorApp.primary, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(service.name, style: const TextStyle(fontSize: 15, color: ColorApp.primary))),
            Text(service.isAvailable ? l10n.availableCount(service.capacity) : l10n.unavailable, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: service.isAvailable ? ColorApp.secondary : ColorApp.error)),
          ]),
          if (service.description.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(l10n.forCases, style: const TextStyle(fontSize: 14, color: ColorApp.primary)),
            const SizedBox(height: 4),
            ...service.description.map(_buildBulletPoint),
          ],
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, right: 16.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('• ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorApp.primary)),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: ColorApp.primary))),
      ]),
    );
  }

  Widget _buildBookButton(BuildContext context, PatientService service, AppLocalizations l10n) {
    return InkWell(
      onTap: service.isAvailable ? () => Navigator.pushNamed(context, BookingScreen.routeName, arguments: service) : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 180, padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: service.isAvailable ? ColorApp.buttonDetails : ColorApp.locationText.withOpacity(0.35),
          borderRadius: BorderRadius.circular(16),
          boxShadow: service.isAvailable ? [BoxShadow(color: ColorApp.secondary.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3))] : null,
        ),
        child: Center(child: Text(service.isAvailable ? l10n.bookAction : l10n.unavailable, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorApp.appAmoled))),
      ),
    );
  }
}
