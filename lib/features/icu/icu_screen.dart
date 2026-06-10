import 'package:flutter/material.dart';

import '../../core/theme/color_app.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/medical_background_icons.dart';
import '../../features/nurseries/patient_service_model.dart';
import '../../features/nurseries/patient_services_repository.dart';
import '../../l10n/app_localizations.dart';

class IcuScreen extends StatefulWidget {
  static const String routeName = 'IcuScreen';
  const IcuScreen({super.key});

  @override
  State<IcuScreen> createState() => _IcuScreenState();
}

class _IcuScreenState extends State<IcuScreen> {
  late Future<List<PatientService>> _servicesFuture;

  @override
  void initState() {
    super.initState();
    _servicesFuture = patientServicesRepository.getCareServices();
  }

  void _refresh() {
    setState(() {
      _servicesFuture = patientServicesRepository.getCareServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? ColorApp.appDark : ColorApp.appLight,
        body: Stack(
          children: [
            const Positioned.fill(child: MedicalIconsBackground()),
            SafeArea(
              child: Column(
                children: [
                  const AppHeader(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
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
                        const SizedBox(width: 12),
                        Text(
                          l10n.icu,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ColorApp.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<PatientService>>(
                      future: _servicesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: ColorApp.primary,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return _buildStateMessage(
                            title: 'تعذر تحميل خدمات العناية',
                            actionText: 'إعادة المحاولة',
                            onAction: _refresh,
                          );
                        }

                        final services = snapshot.data ?? [];
                        if (services.isEmpty) {
                          return _buildStateMessage(
                            title: 'لا توجد خدمات عناية متاحة',
                          );
                        }

                        return RefreshIndicator(
                          color: ColorApp.primary,
                          onRefresh: () async => _refresh(),
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                            itemBuilder: (context, index) =>
                                _buildCareCard(services[index]),
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 14),
                            itemCount: services.length,
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

  Widget _buildCareCard(PatientService service) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? ColorApp.appDark.withOpacity(0.84)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorApp.buttonDetails, width: 1.3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_hospital,
                color: ColorApp.primary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  service.hospitalName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : ColorApp.icons,
                  ),
                ),
              ),
              Text(
                service.availabilityText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: service.isAvailable
                      ? ColorApp.secondary
                      : ColorApp.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            service.name,
            style: const TextStyle(fontSize: 14, color: ColorApp.primary),
          ),
          const SizedBox(height: 8),
          Text(
            service.hospitalAddress.isEmpty
                ? 'العنوان غير محدد'
                : service.hospitalAddress,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white70 : ColorApp.locationText,
            ),
          ),
          if (service.description.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              service.description.join('، '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white70 : ColorApp.locationText,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
