import 'package:flutter/material.dart';
import 'package:shefa/core/constants/assets_app.dart';
import 'package:shefa/core/manager/app_state_manager.dart';
import '../../core/theme/color_app.dart';
import '../../l10n/app_localizations.dart';

class MedicalStaffScreen extends StatefulWidget {
  static const String routeName = 'MedicalStaffScreen';
  const MedicalStaffScreen({super.key});

  @override
  State<MedicalStaffScreen> createState() => _MedicalStaffScreenState();
}

class _MedicalStaffScreenState extends State<MedicalStaffScreen> {
  int _selectedService = 0;
  bool _isSubmitted = false;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _conditionController = TextEditingController();

  String _getServiceTitle(int index, BuildContext context) {
    switch (index) {
      case 0:
        return AppLocalizations.of(context)!.elderlyCare;
      case 1:
        return AppLocalizations.of(context)!.postSurgeryCare;
      case 2:
        return AppLocalizations.of(context)!.newbornFollowUp;
      default:
        return '';
    }
  }

  String _t(String ar, String en) {
    return appStateManager.isArabic ? ar : en;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _conditionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStateManager.isDarkMode
          ? ColorApp.appDark
          : ColorApp.appLight,
      body: _isSubmitted ? _buildSuccessView() : _buildFormView(),
    );
  }

  Widget _buildFormView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ===== الهيدر =====
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 15,
              bottom: 15,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              color: appStateManager.isDarkMode
                  ? ColorApp.icons
                  : ColorApp.appLight,
              border: Border(
                bottom: BorderSide(
                  color: ColorApp.locationText.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorApp.appAmoled.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: ColorApp.primary.withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    size: 28,
                    color: ColorApp.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _t('علي عماد', 'Ali Emad'),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: appStateManager.isDarkMode
                                  ? ColorApp.appLight
                                  : ColorApp.appDark,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text('👋', style: TextStyle(fontSize: 17)),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _t('الفل بنها القليوبيه', 'El Fol, Banha, Qalyubia'),
                        style: TextStyle(
                          fontSize: 12,
                          color: appStateManager.isDarkMode
                              ? ColorApp.appLight.withOpacity(0.7)
                              : ColorApp.locationText,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(AssetsApp.logo, height: 50),
              ],
            ),
          ),

          // ===== صورة + طاقم طبي =====
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.transparent,
                  backgroundImage: const AssetImage(AssetsApp.logoMedical),
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.medicalStaff,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: appStateManager.isDarkMode
                        ? ColorApp.appLight
                        : ColorApp.appDark,
                  ),
                ),
              ],
            ),
          ),

          // ===== الفورم =====
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: appStateManager.isDarkMode
                    ? ColorApp.icons
                    : ColorApp.appLight,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: ColorApp.appAmoled.withOpacity(0.08),

                    spreadRadius: 1,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.medicalStaffServiceDesc,
                    style: TextStyle(
                      color: appStateManager.isDarkMode
                          ? ColorApp.appLight
                          : ColorApp.appDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  ...List.generate(3, (index) {
                    return GestureDetector(
                      onTap: () => setState(() => _selectedService = index),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _selectedService == index
                                      ? ColorApp.textFieldHighlight
                                      : ColorApp.locationText.withOpacity(0.5),
                                  width: 2,
                                ),
                                color: _selectedService == index
                                    ? ColorApp.textFieldHighlight
                                    : Colors.transparent,
                              ),
                              child: _selectedService == index
                                  ? const Icon(
                                      Icons.circle,
                                      size: 10,
                                      color: ColorApp.appLight,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _getServiceTitle(index, context),
                              style: TextStyle(
                                color: appStateManager.isDarkMode
                                    ? ColorApp.appLight
                                    : ColorApp.appDark,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 10),

                  _buildInputField(
                    controller: _nameController,
                    hint: AppLocalizations.of(context)!.patientName,
                  ),
                  const SizedBox(height: 10),
                  _buildInputField(
                    controller: _phoneController,
                    hint: AppLocalizations.of(context)!.phoneNumber,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  _buildInputField(
                    controller: _addressController,
                    hint: AppLocalizations.of(context)!.addressOrLocation,
                  ),
                  const SizedBox(height: 10),
                  _buildInputField(
                    controller: _conditionController,
                    hint: AppLocalizations.of(context)!.medicalCondition,
                  ),
                ],
              ),
            ),
          ),

          // ===== زرار تأكيد الحجز =====
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => setState(() => _isSubmitted = true),
                style: OutlinedButton.styleFrom(
                  backgroundColor: ColorApp.secondary.withOpacity(0.15),
                  side: BorderSide(
                    color: ColorApp.textFieldHighlight.withOpacity(0.6),
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppLocalizations.of(context)!.confirmBooking,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: appStateManager.isDarkMode
                        ? ColorApp.appLight
                        : ColorApp.appDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: appStateManager.isDarkMode
                    ? ColorApp.icons
                    : ColorApp.appLight,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: ColorApp.appAmoled.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.requestDetails,
                    style: const TextStyle(
                      color: ColorApp.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.medicalStaffBooking,
                    style: TextStyle(
                      color: appStateManager.isDarkMode
                          ? ColorApp.appLight
                          : ColorApp.appDark,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 25, color: ColorApp.locationText),
                  _buildDetailRow(
                    AppLocalizations.of(context)!.patientName,
                    _nameController.text.isEmpty
                        ? AppLocalizations.of(context)!.notSpecified
                        : _nameController.text,
                  ),
                  _buildDetailRow(
                    AppLocalizations.of(context)!.phoneNumber,
                    _phoneController.text.isEmpty
                        ? AppLocalizations.of(context)!.notSpecified
                        : _phoneController.text,
                  ),
                  _buildDetailRow(
                    AppLocalizations.of(context)!.address,
                    _addressController.text.isEmpty
                        ? AppLocalizations.of(context)!.notSpecified
                        : _addressController.text,
                  ),
                  _buildDetailRow(
                    AppLocalizations.of(context)!.condition,
                    _conditionController.text.isEmpty
                        ? AppLocalizations.of(context)!.notSpecified
                        : _conditionController.text,
                  ),
                  _buildDetailRow(
                    AppLocalizations.of(context)!.serviceType,
                    _getServiceTitle(_selectedService, context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: ColorApp.textFieldHighlight,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ColorApp.textFieldHighlight.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check,
                color: ColorApp.appLight,
                size: 40,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              AppLocalizations.of(context)!.bookingRequestSent,
              style: const TextStyle(
                color: ColorApp.textFieldHighlight,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: ColorApp.primary),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.backToHome,
                  style: const TextStyle(
                    color: ColorApp.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        color: appStateManager.isDarkMode
            ? ColorApp.appLight
            : ColorApp.appDark,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: appStateManager.isDarkMode
              ? ColorApp.appLight.withOpacity(0.4)
              : ColorApp.locationText,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorApp.textFieldHighlight.withOpacity(0.4),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorApp.textFieldHighlight),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: ColorApp.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: appStateManager.isDarkMode
                    ? ColorApp.appLight
                    : ColorApp.appDark,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
