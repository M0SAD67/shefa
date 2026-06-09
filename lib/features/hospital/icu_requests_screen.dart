import 'package:flutter/material.dart';
import '../../core/theme/color_app.dart';
import '../../core/widgets/hospital_header.dart';
import '../../core/manager/app_state_manager.dart';
import '../../l10n/app_localizations.dart';
import 'icu_request_card.dart';

class IcuRequestsScreen extends StatelessWidget {
  const IcuRequestsScreen({super.key});

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
                  horizontal: 10,
                  vertical: 10,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? ColorApp.icons.withValues(alpha: 0.9)
                      : Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(12),
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
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: ColorApp.primary.withValues(alpha: 0.1),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(6),
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
                          'assets/images/onboard/onboard-2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.icuBookingRequests,
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
                child: ListenableBuilder(
                  listenable: appStateManager,
                  builder: (context, _) {
                    final requests = appStateManager.icuRequests;
                    if (requests.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.local_hospital_rounded, size: 80, color: Colors.grey),
                            const SizedBox(height: 15),
                            Text(
                              l10n.noIcuRequests,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        return IcuRequestCard(request: requests[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
