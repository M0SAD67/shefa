import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class NurseriesScreen extends StatelessWidget {
  static const String routeName = 'NurseriesScreen';
  const NurseriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.nurseries)),
      body: const Center(child: Text('Nurseries Screen')),
    );
  }
}
