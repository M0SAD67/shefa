import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = 'SignupScreen';
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: const Center(child: Text('Sign Up Screen')),
    );
  }
}
