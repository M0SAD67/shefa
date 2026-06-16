import 'package:flutter/material.dart';
import 'package:shefa/core/utils/auth_error_ui_message.dart';
import 'package:shefa/core/widgets/custom_snackbar.dart';
import 'package:shefa/features/auth/auth_repository.dart';
import 'package:shefa/features/auth/success_verification_screen.dart';

import '../../core/theme/color_app.dart';
import '../../l10n/app_localizations.dart';
import '../../core/constants/assets_app.dart';

class OtpScreen extends StatefulWidget {
  static const String routeName = 'OtpScreen';
  final String email;
  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  bool _isLoading = false;
  bool _isResending = false; // 👈 متغير لحالة تحميل إعادة الإرسال

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    String otp = _controllers.map((e) => e.text).join();
    if (otp.length < 6) {
      showCustomSnackBar(
        context,
        message: AppLocalizations.of(context)!.otpIncompleteCode,
      );
      return;
    }

    // 💡 الكود السحري للتطوير (Development Bypass Code)
    // لو كتبت 123456 هيعديك علطول بدون ما يكلم السيرفر
    if (otp == "123456") {
      showCustomSnackBar(
        context,
        message: "تم التخطي بكود التطوير السري التجريبي!",
        backgroundColor: Colors.blue,
        top: true,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SuccessVerificationScreen(),
        ),
      );
      return; // بنوقف الدالة هنا ومبنروحش للـ API
    }

    // ── الكود الطبيعي اللي بيكلم السيرفر لو الكود مش 123456 ──
    // final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);
    try {
      await authRepository.confirmEmail(email: widget.email, otp: otp);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SuccessVerificationScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showCustomSnackBar(
        context,
        message: "تم اعاده ارسال الكود" /* authErrorSnackMessage(e, l10n)*/,
        backgroundColor: ColorApp.success,
        top: true,
        icon: Icons.error_outline,
        maxMessageLines: 8,
        duration: const Duration(seconds: 5),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // 👈 دالة إعادة إرسال الكود للإيميل
  Future<void> _resendCode() async {
    setState(() => _isResending = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      // بنستدعي دالة إعادة الإرسال من الـ repository
      await authRepository.resendOtp(email: widget.email);
      if (!mounted) return;
      showCustomSnackBar(
        context,
        message: "تم إعادة إرسال رمز التأكيد إلى بريدك الإلكتروني بنجاح",
        backgroundColor: Colors.green,
        top: true,
        icon: Icons.check_circle_outline,
      );
    } catch (e) {
      if (!mounted) return;
      showCustomSnackBar(
        context,
        message: authErrorSnackMessage(e, l10n),
        backgroundColor: ColorApp.error,
        top: true,
        icon: Icons.error_outline,
      );
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.appLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.otpVerification,
          style: const TextStyle(
            color: ColorApp.icons,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                AppLocalizations.of(
                  context,
                )!.otpEnterCodeForEmail(widget.email),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: ColorApp.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => _buildOTPBox(context, _controllers[index], index),
                ),
              ),
            ),
            const SizedBox(height: 40),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                  onPressed: _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorApp.primary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.verify,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // 👈 إضافة زرار إعادة الإرسال هنا أسفل زرار التفعيل
            if (_isResending)
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              TextButton(
                onPressed: _resendCode,
                child: const Text(
                  "لم يصلك الرمز؟ إعادة إرسال الكود",
                  style: TextStyle(
                    color: ColorApp.textFieldHighlight,
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

  Widget _buildOTPBox(
    BuildContext context,
    TextEditingController controller,
    int index,
  ) {
    return Container(
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(color: ColorApp.icons, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
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
