import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = 'SignupScreen';
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.signUp)),
      body: Center(child: Text(AppLocalizations.of(context)!.signUp)),
    );
  }
}
