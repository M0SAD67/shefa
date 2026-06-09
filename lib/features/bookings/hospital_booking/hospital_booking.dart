import 'package:flutter/material.dart';
import '../../../core/constants/assets_app.dart';
import '../../../core/theme/color_app.dart';
import '../../../core/widgets/hospital_header.dart';
import '../../../core/manager/app_state_manager.dart';
import '../../../l10n/app_localizations.dart';
import '../../hospital/nursery_request_model.dart';
import 'booking_details.dart';

enum BookingFilter { accepted, rejected }

class HospitalBookingsScreen extends StatefulWidget {
  const HospitalBookingsScreen({super.key});

  @override
  State<HospitalBookingsScreen> createState() => _HospitalBookingsScreenState();
}

class _HospitalBookingsScreenState extends State<HospitalBookingsScreen> {
  BookingFilter _selectedFilter = BookingFilter.accepted;

  @override
  void initState() {
    super.initState();
    // Fetch reservations from API when screen loads safely after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appStateManager.fetchReservations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: appStateManager,
      builder: (context, child) {
        final List<dynamic> displayedRequests =
            _selectedFilter == BookingFilter.accepted
            ? appStateManager.acceptedBookings
            : appStateManager.rejectedBookings;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: isDark ? ColorApp.appDark : ColorApp.appLight,
            body: Column(
              children: [
                // Using the pre-made Hospital Header
                const HospitalHeader(),

                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Text(
                        l10n.bookingsTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : ColorApp.textLight,
                        ),
                      ),
                      const Spacer(),

                      Container(
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: isDark ? ColorApp.icons : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: ColorApp.secondary,
                            width: 1,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<BookingFilter>(
                            value: _selectedFilter,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: ColorApp.secondary,
                              size: 20,
                            ),
                            dropdownColor: isDark
                                ? ColorApp.icons
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            style: TextStyle(
                              color: isDark ? Colors.white : ColorApp.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            onChanged: (BookingFilter? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedFilter = newValue;
                                });
                              }
                            },
                            items: [
                              DropdownMenuItem(
                                value: BookingFilter.accepted,
                                child: Text(
                                  l10n.acceptedBookings,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white
                                        : ColorApp.primary,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: BookingFilter.rejected,
                                child: Text(
                                  l10n.rejectedBookings,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white
                                        : ColorApp.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
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

                      RefreshIndicator(
                        onRefresh: () => appStateManager.fetchReservations(),
                        child: appStateManager.isLoadingReservations
                            ? const Center(child: CircularProgressIndicator())
                            : displayedRequests.isEmpty
                            ? SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.inbox_outlined,
                                        size: 64,
                                        color: isDark
                                            ? Colors.grey[600]
                                            : ColorApp.locationText.withValues(
                                                alpha: 0.4,
                                              ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        _selectedFilter ==
                                                BookingFilter.accepted
                                            ? 'لا توجد حجوزات مقبولة'
                                            : 'لا توجد حجوزات مرفوضة',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: isDark
                                              ? Colors.grey[400]
                                              : ColorApp.locationText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 10,
                                ),
                                itemCount: displayedRequests.length,
                                itemBuilder: (context, index) {
                                  final request = displayedRequests[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                    ),
                                    child: _buildBookingCard(
                                      request,
                                      isDark,
                                      l10n,
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookingCard(
    dynamic request,
    bool isDark,
    AppLocalizations l10n,
  ) {
    bool isNursery = request is NurseryRequest;
    String nameLabel = isNursery ? l10n.childNameLabel : l10n.patientNameLabel;
    String nameValue = isNursery ? request.childName : request.patientName;
    String phoneValue = request.phone;
    String statusValue = request.status;
    String serviceTypeValue = request.serviceType;
    String timeValue = request.time;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark
            ? ColorApp.icons.withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : ColorApp.buttonDetails,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _selectedFilter == BookingFilter.accepted
                      ? ColorApp.success.withValues(alpha: 0.15)
                      : ColorApp.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedFilter == BookingFilter.accepted
                      ? l10n.acceptedStatus
                      : l10n.rejectedStatus,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _selectedFilter == BookingFilter.accepted
                        ? ColorApp.success
                        : ColorApp.error,
                  ),
                ),
              ),
              Text(
                timeValue,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark
                      ? Colors.grey[400]
                      : ColorApp.locationText.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: isDark ? Colors.grey[800] : Colors.grey[200]),
          const SizedBox(height: 8),

          // Patient Name Row
          _buildInfoRow(nameLabel, nameValue, isDark),
          const SizedBox(height: 8),

          // Phone Row
          _buildInfoRow(l10n.phoneLabelText, phoneValue, isDark),
          const SizedBox(height: 8),

          // Status Row
          _buildInfoRow(l10n.statusLabel, statusValue, isDark),
          const SizedBox(height: 8),

          // Service Row
          _buildInfoRow(l10n.serviceTypeLabel, serviceTypeValue, isDark),

          const SizedBox(height: 16),

          Center(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BookingDetailsScreen(requestData: request),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? ColorApp.primary.withValues(alpha: 0.6)
                      : ColorApp.buttonDetails,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  l10n.detailsButton,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : ColorApp.appDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.grey[300] : ColorApp.primary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
