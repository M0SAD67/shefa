import 'package:flutter/material.dart';
import 'dart:async'; // عشان نستخدم الـ Timer للتحويل التلقائي
import 'package:shefa/features/home/main_shell.dart';
import '../../core/constants/assets_app.dart';

import '../../core/theme/color_app.dart';
import '../../l10n/app_localizations.dart';

class SuccessVerificationScreen extends StatefulWidget {
  static const String routeName = 'SuccessVerificationScreen';
  const SuccessVerificationScreen({super.key});

  @override
  State<SuccessVerificationScreen> createState() =>
      _SuccessVerificationScreenState();
}

class _SuccessVerificationScreenState extends State<SuccessVerificationScreen> {
  @override
  void initState() {
    super.initState();
    // تحويل تلقائي للصفحة الرئيسية بعد 3 ثواني مثلاً
    Timer(const Duration(seconds: 3), () {
      // Navigator.pushReplacementNamed(context, 'HomeScreen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.appLight,
      body: Stack(
        children: [
          // المحتوى الأساسي في المنتصف
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // أيقونة الصح الخضراء داخل دائرة
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: ColorApp.secondary, // اللون الأخضر من الصورة
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: ColorApp.appLight,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 30),
                // نص تم التحقق
                Text(
                  AppLocalizations.of(context)!.phoneVerified,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ColorApp.primary, // اللون الأزرق من الصورة
                  ),
                ),
                const SizedBox(height: 10),
                // نص التحويل التلقائي
                Text(
                  AppLocalizations.of(context)!.redirectToHome,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: ColorApp.primary),
                ),
                const SizedBox(height: 100), // مسافة قبل الصورة السفلية
              ],
            ),
          ),
          // الصورة السفلية للطاقم الطبي
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Image.asset(
              AssetsApp.bgOnboardOpacity, // تأكد من نفس المسار
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width * 0.9,
            ),
          ),
        ],
      ),
    );
  }
}
