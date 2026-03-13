import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class BookingsScreen extends StatelessWidget {
  static const String routeName = 'BookingsScreen';
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.bookings)),
      body: const Center(child: Text('Bookings Screen')),
    );
  }
}
