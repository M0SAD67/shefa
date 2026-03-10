import 'package:flutter/material.dart';

class NurseriesScreen extends StatelessWidget {
  const NurseriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حضانات')),
      body: const Center(child: Text('Nurseries Screen')),
    );
  }
}
