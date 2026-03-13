import 'package:flutter/material.dart';
import 'dart:async'; // عشان نستخدم الـ Timer للتحويل التلقائي

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
      backgroundColor: Colors.white,
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
                    color: Color(0xFF80B541), // اللون الأخضر من الصورة
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 50),
                ),
                const SizedBox(height: 30),
                // نص تم التحقق
                const Text(
                  'تم التحقق من رقم الهاتف',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D7FA3), // اللون الأزرق من الصورة
                  ),
                ),
                const SizedBox(height: 10),
                // نص التحويل التلقائي
                const Text(
                  'سيتم تحويلك إلى الصفحة الرئيسية خلال لحظات',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF2D7FA3)),
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
              'assets/images/background/background-reduce-opacity.png', // تأكد من نفس المسار
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width * 0.9,
            ),
          ),
        ],
      ),
    );
  }
}
