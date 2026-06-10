import 'package:flutter/material.dart';

import '../../core/constants/assets_app.dart';
import '../../core/theme/color_app.dart';
import '../../core/widgets/app_header.dart';
import '../../l10n/app_localizations.dart';
import 'IncubatorsDetailsScreen.dart';
import 'patient_service_model.dart';
import 'patient_services_repository.dart';

class IncubatorsScreen extends StatefulWidget {
  static const String routeName = 'IncubatorsScreen';
  const IncubatorsScreen({Key? key}) : super(key: key);

  @override
  State<IncubatorsScreen> createState() => _IncubatorsScreenState();
}

class _IncubatorsScreenState extends State<IncubatorsScreen> {
  late Future<List<PatientService>> _servicesFuture;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _servicesFuture = patientServicesRepository.getNurseryServices();
  }

  void _refresh() {
    setState(() {
      _servicesFuture = patientServicesRepository.getNurseryServices();
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: ColorApp.buttonDetails,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: ColorApp.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorApp.secondary, width: 1.5),
                      color: isDark ? ColorApp.appAmoled : Colors.white,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        AssetsApp.icOnboard1,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.nurseries,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ColorApp.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDark ? ColorApp.appAmoled : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorApp.secondary, width: 1),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              onChanged: (value) => setState(() {
                                _query = value.trim();
                              }),
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 11,
                              ),
                              decoration: InputDecoration(
                                hintText: l10n.searchHospitalOrArea,
                                hintStyle: TextStyle(
                                  color: ColorApp.locationText.withOpacity(0.7),
                                  fontSize: 11,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(
                                  bottom: 12,
                                ),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.search,
                            color: ColorApp.locationText,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
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
                        opacity: 0.15,
                        child: Image.asset(
                          AssetsApp.bgOnboardOpacity,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder<List<PatientService>>(
                    future: _servicesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: ColorApp.primary,
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return _buildStateMessage(
                          title: l10n.failedToLoadNurseries,
                          actionText: l10n.retry,
                          onAction: _refresh,
                        );
                      }

                      final services = _filterServices(snapshot.data ?? []);
                      if (services.isEmpty) {
                        return _buildStateMessage(
                          title: l10n.noNurseriesAvailable,
                        );
                      }

                      return RefreshIndicator(
                        color: ColorApp.primary,
                        onRefresh: () async => _refresh(),
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10,
                          ),
                          itemBuilder: (context, index) {
                            return _buildHospitalCard(
                              context: context,
                              service: services[index],
                            );
                          },
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 16),
                          itemCount: services.length,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PatientService> _filterServices(List<PatientService> services) {
    if (_query.isEmpty) return services;
    final query = _query.toLowerCase();
    return services.where((service) {
      return service.hospitalName.toLowerCase().contains(query) ||
          service.hospitalAddress.toLowerCase().contains(query) ||
          service.name.toLowerCase().contains(query);
    }).toList();
  }

  Widget _buildStateMessage({
    required String title,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: ColorApp.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: 12),
            TextButton(onPressed: onAction, child: Text(actionText)),
          ],
        ],
      ),
    );
  }

  Widget _buildHospitalCard({
    required BuildContext context,
    required PatientService service,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark
            ? ColorApp.appDark.withOpacity(0.8)
            : Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: ColorApp.buttonDetails, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: ColorApp.appAmoled.withOpacity(0.04),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.hospitalName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : ColorApp.icons,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.addressLabel(service.hospitalAddress.isEmpty ? l10n.notSpecified : service.hospitalAddress),
                  style: const TextStyle(fontSize: 13, color: ColorApp.primary),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.child_care,
                      color: ColorApp.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        service.name,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? Colors.white70
                              : ColorApp.locationText,
                        ),
                      ),
                    ),
                    Text(
                      service.isAvailable ? l10n.availableCount(service.capacity) : l10n.unavailable,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: service.isAvailable
                            ? ColorApp.secondary
                            : ColorApp.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  IncubatorDetailsScreen.routeName,
                  arguments: service,
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: ColorApp.buttonDetails,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: ColorApp.secondary.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  l10n.detailsButton,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: ColorApp.appDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
