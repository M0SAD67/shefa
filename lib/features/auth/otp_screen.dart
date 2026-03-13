import 'package:flutter/material.dart';

import '../../core/theme/color_app.dart';
import '../../l10n/app_localizations.dart';
import '../../core/constants/assets_app.dart';

class VerificationScreen extends StatelessWidget {
  static const String routeName = 'VerificationScreen';
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.appLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Phone Verification',
          style: TextStyle(color: ColorApp.icons, fontWeight: FontWeight.bold),
        ),
        actions: [
          // السهم اللي في المربع الصغير جهة اليمين كما بالصورة
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: ColorApp.buttonDetails,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_forward, color: ColorApp.icons),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // النص العلوي
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                AppLocalizations.of(context)!.otpVerification,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: ColorApp.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // مربعات الـ OTP الستة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) => _buildOTPBox(context)),
              ),
            ),

            const SizedBox(height: 25),

            // نص إعادة إرسال الرمز
            TextButton(
              onPressed: () {},
              child: Text(
                AppLocalizations.of(context)!.phoneVerified,
                style: const TextStyle(
                  color: ColorApp.textFieldHighlight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 40),

            Image.asset(
              AssetsApp.bgOnboardOpacity,
              width: MediaQuery.of(context).size.width * 0.9,
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت المربع الواحد للكود
  Widget _buildOTPBox(BuildContext context) {
    return Container(
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(color: ColorApp.icons, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        onChanged: (value) {
          if (value.length == 1) FocusScope.of(context).nextFocus();
        },
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),
      ),
    );
  }
}
