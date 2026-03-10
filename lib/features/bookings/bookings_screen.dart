import 'package:flutter/material.dart';

class BookingsScreen extends StatelessWidget {
  static const String routeName = 'BookingsScreen';
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلبات الحجز')),
      body: const Center(child: Text('Bookings Screen')),
    );
  }
}
