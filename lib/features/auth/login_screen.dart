import 'package:flutter/material.dart';
import 'package:shefa/features/auth/otp_screen.dart';
import 'package:shefa/features/auth/success_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPhoneSelected = true;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 80),
              // اللوجو
              Center(child: Image.asset('assets/logo/logo.png', height: 100)),
              const SizedBox(height: 40),
              const Text(
                'تسجيل دخول',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D7FA3),
                ),
              ),
              const SizedBox(height: 30),

              // كارت تسجيل الدخول
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF083345),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    // منطقة التبديل (Tabs) مع البوردر الخارجي المطلب
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D7FA3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF5399B7),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildTabButton('الايميل', !isPhoneSelected, () {
                            setState(() => isPhoneSelected = false);
                          }),
                          _buildTabButton('رقم التليفون', isPhoneSelected, () {
                            setState(() => isPhoneSelected = true);
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // العرض الشرطي للحقول
                    if (isPhoneSelected) ...[
                      _buildPhoneInput(),
                    ] else ...[
                      _buildEmailInput('البريد الإلكتروني'),
                      const SizedBox(height: 15),
                      _buildPasswordInput(),
                    ],

                    const SizedBox(height: 25),

                    // زرار الإرسال أو التسجيل
                    _buildMainButton(
                      isPhoneSelected ? 'ارسال الرمز' : 'تسجيل',
                      onTap: () {
                        if (isPhoneSelected) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VerificationScreen(),
                            ),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 15),

                    // هل نسيت كلمة المرور
                    if (!isPhoneSelected)
                      Align(
                        alignment: Alignment.centerRight, // يمين عشان الـ RTL
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'هل نسيت كلمة المرور؟',
                            style: TextStyle(
                              color: Color(0xFF70B44F),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),

                    // النص السفلي لإنشاء الحساب
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'ليس لديك حساب؟ ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'إنشاء حساب',
                            style: TextStyle(
                              color: Color(0xFF70B44F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // أيقونات التواصل الاجتماعي
              if (!isPhoneSelected)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialIcon('assets/icon/google.png'),
                    const SizedBox(width: 15),
                    _socialIcon('assets/icon/apple.png'),
                    const SizedBox(width: 15),
                    _socialIcon('assets/icon/Facebook.png'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجت زر التبديل (Tabs)
  Widget _buildTabButton(String title, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? const Color(0xFF083345) : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  // حقل رقم التليفون
  Widget _buildPhoneInput() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF70B44F)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text('+20 ▼', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: 10),
        Expanded(child: _buildTextField(hint: 'رقم التليفون')),
      ],
    );
  }

  // حقل البريد الإلكتروني
  Widget _buildEmailInput(String hint) {
    return _buildTextField(hint: hint);
  }

  // حقل كلمة المرور
  Widget _buildPasswordInput() {
    return TextField(
      obscureText: !isPasswordVisible,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'الرقم السري',
        hintStyle: const TextStyle(color: Colors.grey),
        suffixIcon: IconButton(
          // تم تغييرها لـ suffix عشان الـ RTL
          icon: Icon(
            isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off_outlined,
            color: Colors.grey,
          ),
          onPressed: () =>
              setState(() => isPasswordVisible = !isPasswordVisible),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF70B44F)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF70B44F)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // حقل إدخال عام
  Widget _buildTextField({required String hint}) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF70B44F)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF70B44F)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // زرار تسجيل الدخول الرئيسي
  Widget _buildMainButton(String title, {VoidCallback? onTap}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF70B44F),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // أيقونة سوشيال ميديا
  Widget _socialIcon(String path) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.transparent,
      child: Image.asset(path),
    );
  }
}
