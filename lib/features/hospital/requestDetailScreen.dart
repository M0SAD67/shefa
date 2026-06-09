import 'package:flutter/material.dart';
import '../../core/theme/color_app.dart';
import '../../core/widgets/hospital_header.dart';
import '../../core/manager/app_state_manager.dart';
import '../../l10n/app_localizations.dart';
import 'nursery_request_model.dart';

class RequestDetailsScreen extends StatelessWidget {
  final NurseryRequest request;

  const RequestDetailsScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: isDark ? ColorApp.appDark : ColorApp.appLight,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/background-reduce-opacity.png',
              fit: BoxFit.cover,
              opacity: AlwaysStoppedAnimation(isDark ? 0.15 : 0.6),
            ),
          ),
          Column(
            children: [
              const HospitalHeader(),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? ColorApp.icons.withValues(alpha: 0.9)
                      : Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? Colors.grey[800]!
                        : ColorApp.primary.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
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
                        color: ColorApp.primary.withValues(alpha: 0.1),
                        shape: BoxShape.rectangle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          isAr ? Icons.arrow_forward : Icons.arrow_back,
                          color: isDark ? Colors.white : ColorApp.primary,
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
                          color: ColorApp.primary.withValues(alpha: 0.3),
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
                    Expanded(
                      child: Text(
                        request.serviceType,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : ColorApp.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark
                          ? ColorApp.icons.withValues(alpha: 0.9)
                          : Colors.white.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isDark
                            ? Colors.grey[800]!
                            : ColorApp.primary.withValues(alpha: 0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorApp.icons.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: -10,
                            left: isAr ? 10 : null,
                            right: isAr ? null : 10,
                            child: Opacity(
                              opacity: isDark ? 0.04 : 0.1,
                              child: Image.asset(
                                'assets/images/onboard/onboard-1.png',
                                width: 140,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    request.time,
                                    style: TextStyle(
                                      color: isDark ? Colors.grey[400] : ColorApp.locationText,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
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
                                Divider(
                                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                                ),
                                const SizedBox(height: 12),
                                _buildDetailRow(
                                  l10n.childNameLabel,
                                  request.childName,
                                  isDark,
                                ),
                                const SizedBox(height: 12),
                                _buildDetailRow(
                                  l10n.phoneLabelText,
                                  request.phone,
                                  isDark,
                                ),
                                const SizedBox(height: 12),
                                _buildDetailRow(
                                  l10n.statusLabel,
                                  request.status,
                                  isDark,
                                ),
                                const SizedBox(height: 12),
                                _buildDetailRow(
                                  l10n.serviceTypeLabel,
                                  request.serviceType,
                                  isDark,
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          appStateManager.acceptNursery(request);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          decoration: BoxDecoration(
                                            color: ColorApp.secondary,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Center(
                                            child: Text(
                                              l10n.acceptRequestButton,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          appStateManager.rejectNursery(request);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? Colors.white.withValues(alpha: 0.1)
                                                : ColorApp.locationText.withValues(alpha: 0.3),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Center(
                                            child: Text(
                                              l10n.rejectRequestButton,
                                              style: TextStyle(
                                                color: isDark ? Colors.white : ColorApp.icons,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.grey[400] : ColorApp.primary.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? ColorApp.primary.withValues(alpha: 0.2) : const Color(0xFFF0F4F8),
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
}
