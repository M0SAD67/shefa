import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class MedicalStaffScreen extends StatelessWidget {
  static const String routeName = 'MedicalStaffScreen';
  const MedicalStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.medicalStaff)),
      body: const Center(child: Text('Medical Staff Screen')),
    );
  }
}
