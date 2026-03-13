import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class IcuScreen extends StatelessWidget {
  static const String routeName = 'IcuScreen';
  const IcuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.icu)),
      body: const Center(child: Text('ICU Screen')),
    );
  }
}
