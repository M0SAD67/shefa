import 'package:flutter/material.dart';

import '../../core/constants/assets_app.dart';
import '../../core/theme/color_app.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/custom_snackbar.dart';
import '../../l10n/app_localizations.dart';
import 'patient_service_model.dart';
import 'patient_services_repository.dart';

class BookingScreen extends StatefulWidget {
  static const String routeName = 'BookingScreen';
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _childNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _conditionController = TextEditingController();

  int _selectedBookingType = 1;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _childNameController.dispose();
    _phoneController.dispose();
    _conditionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = ModalRoute.of(context)?.settings.arguments as PatientService?;
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
                      child: Opacity(opacity: 0.15, child: Image.asset(AssetsApp.bgOnboardOpacity, fit: BoxFit.contain)),
                    ),
                  ),
                  if (service == null)
                    Center(child: Text(l10n.noServiceData, style: const TextStyle(color: ColorApp.primary)))
                  else
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Column(children: [
                        _buildBookingFormCard(service, l10n),
                        const SizedBox(height: 30),
                        _buildConfirmButton(service, l10n),
                        const SizedBox(height: 20),
                      ]),
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
      child: Row(children: [
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
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ColorApp.secondary, width: 1.5), color: isDark ? ColorApp.appAmoled : Colors.white),
          child: ClipOval(child: Image.asset(AssetsApp.icOnboard1, fit: BoxFit.cover)),
        ),
        const SizedBox(width: 12),
        Text(l10n.nurseries, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: ColorApp.primary)),
      ]),
    );
  }

  Widget _buildBookingFormCard(PatientService service, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: isDark ? ColorApp.appDark.withOpacity(0.8) : Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: ColorApp.buttonDetails, width: 1.5),
        boxShadow: [BoxShadow(color: ColorApp.appAmoled.withOpacity(0.04), blurRadius: 10, spreadRadius: 2, offset: const Offset(0, 4))],
      ),
      child: Column(children: [
        Text(service.hospitalName, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : ColorApp.icons)),
        const SizedBox(height: 10),
        Text(service.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: ColorApp.primary)),
        const SizedBox(height: 24),
        _buildRadioOption(title: l10n.nurseries, value: 1),
        const SizedBox(height: 10),
        _buildRadioOption(title: l10n.nurseryNicuOption, value: 2),
        const SizedBox(height: 24),
        _buildTextField(controller: _childNameController, hintText: l10n.childNameHint),
        _buildTextField(controller: _phoneController, hintText: l10n.phoneHint, isPhone: true),
        _buildTextField(controller: _conditionController, hintText: l10n.medicalConditionHint),
      ]),
    );
  }

  Widget _buildRadioOption({required String title, required int value}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () => setState(() => _selectedBookingType = value),
      child: Row(children: [
        Radio<int>(value: value, groupValue: _selectedBookingType, activeColor: ColorApp.secondary, onChanged: (int? newValue) => setState(() => _selectedBookingType = newValue!)),
        Icon(value == 1 ? Icons.child_care : Icons.baby_changing_station, color: ColorApp.primary, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(title, style: TextStyle(fontSize: 16, color: isDark ? Colors.white : ColorApp.icons))),
      ]),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hintText, bool isPhone = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller, textAlign: TextAlign.center,
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: isDark ? Colors.white54 : ColorApp.locationText.withOpacity(0.6), fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          filled: true, fillColor: isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.5),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: ColorApp.secondary, width: 1)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: ColorApp.primary, width: 1.5)),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(PatientService service, AppLocalizations l10n) {
    return InkWell(
      onTap: _isSubmitting ? null : () => _submitBooking(service, l10n),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 200, padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: _isSubmitting ? ColorApp.locationText.withOpacity(0.35) : ColorApp.buttonDetails,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: ColorApp.secondary.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Center(
          child: _isSubmitting
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: ColorApp.appAmoled))
              : Text(l10n.confirmBooking, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorApp.appAmoled)),
        ),
      ),
    );
  }

  Future<void> _submitBooking(PatientService service, AppLocalizations l10n) async {
    final childName = _childNameController.text.trim();
    final phone = _phoneController.text.trim();
    final condition = _conditionController.text.trim();

    if (childName.length < 2 || phone.isEmpty || condition.isEmpty) {
      showCustomSnackBar(context, message: l10n.pleaseCompleteBookingData, icon: Icons.error_outline);
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await patientServicesRepository.bookChildcare(
        serviceId: service.id, type: _selectedBookingType == 2 ? 'nicu' : 'normal',
        childName: childName, phone: phone, condition: condition,
      );
      if (!mounted) return;
      Navigator.pushNamed(context, 'BookingConfirmationScreen');
    } catch (e) {
      if (!mounted) return;
      showCustomSnackBar(context, message: e.toString(), icon: Icons.error_outline);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
