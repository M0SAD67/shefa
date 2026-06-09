import 'package:flutter/material.dart';
import '../../core/theme/color_app.dart';
import '../../core/widgets/hospital_header.dart';
import '../../l10n/app_localizations.dart';
import '../../core/manager/app_state_manager.dart';
import '../../core/cache/cache_helper.dart';
import 'bookingChildrensNurseries.dart';
import 'icu_requests_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshNotifications();
    });
  }

  Future<void> _refreshNotifications() async {
    final token = CacheHelper.getData(key: 'token') as String?;
    if (token != null) {
      final String username =
          CacheHelper.getData(key: 'profile_name') as String? ?? '';
      await appStateManager.fetchHospitalData(token, username);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return ListenableBuilder(
      listenable: appStateManager,
      builder: (context, child) {
        // Build notifications list dynamically from real API data
        final List<Map<String, dynamic>> notifications = [];

        // 1. Add API notifications first (official backend notifications)
        notifications.addAll(appStateManager.apiNotifications);

        // 2. Fallback to requests if API notifications are empty
        if (notifications.isEmpty) {
          for (int i = 0; i < appStateManager.icuRequests.length; i++) {
            final req = appStateManager.icuRequests[i];
            notifications.add({
              'id': 'icu_$i',
              'time': req.time,
              'title': 'طلب رعاية عناية مركزة للمريض: ${req.patientName}',
              'badge': '1',
              'buttonText': l10n.notifRequestDetails,
              'action': 'icu',
            });
          }
          for (int i = 0; i < appStateManager.nurseryRequests.length; i++) {
            final req = appStateManager.nurseryRequests[i];
            notifications.add({
              'id': 'nursery_$i',
              'time': req.time,
              'title': 'حجز حضانة جديد للطفل: ${req.childName}',
              'badge': '1',
              'buttonText': l10n.notifBookingRequestsButton,
              'action': 'requests',
            });
          }
        }

        // 3. Add alerts for bed capacity if empty or low
        if (appStateManager.nurseriesKids <= 1 &&
            appStateManager.nurseriesKids >= 0) {
          notifications.add({
            'id': 'alert_nursery',
            'time': 'الآن',
            'title': appStateManager.nurseriesKids == 0
                ? 'تنبيه: حضانات الأطفال ممتلئة بالكامل!'
                : 'تنبيه: متبقي سرير حضانة أطفال واحد فقط!',
            'badge': null,
            'buttonText': l10n.notifAvailablePlacesButton,
            'action': 'home',
            'isAlert': true,
            'isDanger': appStateManager.nurseriesKids == 0,
          });
        }

        if (appStateManager.icuAdults <= 1 && appStateManager.icuAdults >= 0) {
          notifications.add({
            'id': 'alert_icu',
            'time': 'الآن',
            'title': appStateManager.icuAdults == 0
                ? 'تنبيه: العناية المركزة للكبار ممتلئة بالكامل!'
                : 'تنبيه: متبقي سرير عناية مركزة للكبار واحد فقط!',
            'badge': null,
            'buttonText': l10n.notifAvailablePlacesButton,
            'action': 'home',
            'isAlert': true,
            'isDanger': appStateManager.icuAdults == 0,
          });
        }

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
                  const HospitalHeader(showNotificationIcon: false),
                  // Title Row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isDark ? ColorApp.icons : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isAr ? Icons.arrow_back : Icons.arrow_forward,
                              color: isDark ? Colors.white : Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.notificationsTitle,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : ColorApp.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refreshNotifications,
                      child: notifications.isEmpty
                          ? SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.6,
                                alignment: Alignment.center,
                                child: _buildEmptyState(isDark, l10n),
                              ),
                            )
                          : _buildNotificationsList(
                              notifications,
                              isDark,
                              l10n,
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: ColorApp.primary.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
              ),
              const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 70,
                color: Color(0xFF90A4AE),
              ),
              PositionedDirectional(
                top: 25,
                end: 25,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF90A4AE),
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            l10n.noNotifications,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF37474F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.notificationsSubtitle,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(
    List<Map<String, dynamic>> notifications,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left/Right green indicator bar based on language direction
        Container(
          width: 8,
          margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
          decoration: BoxDecoration(
            color: ColorApp.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        // Notifications list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: isDark
                      ? ColorApp.icons.withValues(alpha: 0.95)
                      : Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: ColorApp.secondary.withValues(
                      alpha: 0.5,
                    ), // Light green border
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time row
                    Text(
                      notif['time'],
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    // Content row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notif['title'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: notif['isAlert'] == true
                                  ? (notif['isDanger'] == true
                                        ? ColorApp.error
                                        : Colors.red[700])
                                  : (isDark ? Colors.white : ColorApp.primary),
                            ),
                          ),
                        ),
                        if (notif['badge'] != null)
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: ColorApp.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              notif['badge'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Action button
                    GestureDetector(
                      onTap: () {
                        if (notif['action'] == 'icu') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const IcuRequestsScreen(),
                            ),
                          );
                        } else if (notif['action'] == 'requests') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const NurseryRequestsScreen(),
                            ),
                          );
                        } else if (notif['action'] == 'home') {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? ColorApp.primary.withValues(alpha: 0.2)
                              : ColorApp.secondary.withValues(
                                  alpha: 0.2,
                                ), // Light green/primary button
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          notif['buttonText'],
                          style: TextStyle(
                            color: isDark ? Colors.white : ColorApp.secondary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
