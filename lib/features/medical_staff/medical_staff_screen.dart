import 'package:flutter/material.dart';

class MedicalStaffScreen extends StatelessWidget {
  const MedicalStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طاقم طبي')),
      body: const Center(child: Text('Medical Staff Screen')),
    );
  }
}
