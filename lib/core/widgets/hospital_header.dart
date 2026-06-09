import 'package:flutter/material.dart';
import '../../features/hospital/notifications_screen.dart';
import '../../l10n/app_localizations.dart';
import '../constants/assets_app.dart';
import '../theme/color_app.dart';
import '../manager/app_state_manager.dart';

class HospitalHeader extends StatefulWidget {
  final bool showNotificationIcon;

  const HospitalHeader({super.key, this.showNotificationIcon = true});

  @override
  State<HospitalHeader> createState() => _HospitalHeaderState();
}

class _HospitalHeaderState extends State<HospitalHeader> {
  late double _bellWidth;
  late double _spacingWidth;

  @override
  void initState() {
    super.initState();
    _bellWidth = 25.0;
    _spacingWidth = 10.0;
    appStateManager.addListener(_onAppStateChanged);

    if (!widget.showNotificationIcon) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _bellWidth = 0.0;
            _spacingWidth = 0.0;
          });
        }
      });
    }
  }

  void _onAppStateChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    appStateManager.removeListener(_onAppStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final currentBellWidth = widget.showNotificationIcon ? 25.0 : _bellWidth;
    final currentSpacingWidth = widget.showNotificationIcon
        ? 10.0
        : _spacingWidth;

    final String hospitalName = appStateManager.userName.isNotEmpty
        ? appStateManager.userName
        : l10n.hospitalName;
    final String hospitalAddress = appStateManager.userAddress.isNotEmpty
        ? appStateManager.userAddress
        : l10n.hospitalLocation;
    final int unreadCount = appStateManager.unreadNotificationsCount;

    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 12),
      decoration: BoxDecoration(
        color: isDark ? ColorApp.appDark : ColorApp.appLight,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  width: currentBellWidth,
                  height: 25,
                  child: ClipRect(
                    child: OverflowBox(
                      maxWidth: 25,
                      minWidth: 25,
                      maxHeight: 25,
                      minHeight: 25,
                      alignment: AlignmentDirectional.centerStart,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsScreen(),
                            ),
                          );
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOut,
                              width: currentBellWidth,
                              height: 25,
                              child: ClipRect(
                                child: OverflowBox(
                                  maxWidth: 25,
                                  minWidth: 25,
                                  maxHeight: 25,
                                  minHeight: 25,
                                  alignment: AlignmentDirectional.centerStart,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const NotificationsScreen(),
                                        ),
                                      );
                                    },
                                    child: Image.asset(
                                      AssetsApp.alarmLogo,
                                      height: 23,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (unreadCount > 0 && widget.showNotificationIcon)
                              PositionedDirectional(
                                end: -6,
                                top: -6,
                                child: IgnorePointer(
                                  child: Container(
                                    padding: unreadCount > 9
                                        ? const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 1,
                                          )
                                        : const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: unreadCount > 9
                                          ? BoxShape.rectangle
                                          : BoxShape.circle,
                                      borderRadius: unreadCount > 9
                                          ? BorderRadius.circular(10)
                                          : null,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Center(
                                      child: Text(
                                        unreadCount > 9
                                            ? '9+'
                                            : unreadCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  width: currentSpacingWidth,
                  height: 25,
                ),

                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(AssetsApp.hospitalLogo, height: 38),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hospitalName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: isDark
                                  ? ColorApp.textDark
                                  : ColorApp.textLight,
                            ),
                          ),
                          Text(
                            hospitalAddress,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: ColorApp.locationText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                SizedBox(
                  width: 55,
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Hero(
                      tag: 'shifa_logo',
                      child: Image.asset(AssetsApp.logo, height: 45),
                    ),
                  ),
                ),
              ],
            ),

            Container(
              height: 1.2,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorApp.primary.withValues(alpha: 0.0),
                    ColorApp.primary.withValues(alpha: 0.4),
                    ColorApp.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
