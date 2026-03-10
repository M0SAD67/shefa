import 'package:flutter/material.dart';

class IcuScreen extends StatelessWidget {
  const IcuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عناية مركزة')),
      body: const Center(child: Text('ICU Screen')),
    );
  }
}
