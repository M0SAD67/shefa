import 'package:flutter/material.dart';
import '../../core/constants/assets_app.dart';
import '../../core/theme/color_app.dart';
import '../../core/widgets/app_header.dart';
import '../../l10n/app_localizations.dart';

class BookingConfirmationScreen extends StatelessWidget {
  static const String routeName = 'BookingConfirmationScreen';
  const BookingConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final hospitalName = args?['hospitalName'] ?? l10n.hospitalName;
    final childName = args?['childName'] ?? '';
    final phone = args?['phone'] ?? '';
    final condition = args?['condition'] ?? '';
    final serviceType = args?['serviceType'] ?? l10n.nurseries;

    return Scaffold(
      backgroundColor: isDark ? ColorApp.appDark : ColorApp.appLight,
      body: Column(
        children: [
          const AppHeader(),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: ColorApp.buttonDetails,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      isAr ? Icons.arrow_forward : Icons.arrow_back,
                      color: ColorApp.primary,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorApp.secondary, width: 1.5),
                    color: isDark ? ColorApp.appAmoled : Colors.white,
                  ),
                  child: ClipOval(
                    child: Image.asset(AssetsApp.icOnboard1, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.nurseries,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: ColorApp.primary,
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
                      _buildRequestDataCard(
                        context,
                        isDark,
                        l10n,
                        hospitalName,
                        childName,
                        phone,
                        condition,
                        serviceType,
                      ),
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: ColorApp.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: ColorApp.icons,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.bookingRequestSent,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: ColorApp.secondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestDataCard(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
    String hospitalName,
    String childName,
    String phone,
    String condition,
    String serviceType,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: isDark
            ? ColorApp.appDark.withOpacity(0.8)
            : Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: ColorApp.buttonDetails, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: ColorApp.appAmoled.withOpacity(0.04),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            l10n.bookingRequestData,
            style: const TextStyle(
              color: ColorApp.locationText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hospitalName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : ColorApp.icons,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${l10n.childNameLabel}: $childName',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : ColorApp.icons,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.phoneLabelText}: $phone',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : ColorApp.icons,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.conditionLabel}: $condition',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : ColorApp.icons,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.serviceTypeLabel}: $serviceType',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : ColorApp.icons,
            ),
          ),
        ],
      ),
    );
  }
}
