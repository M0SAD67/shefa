import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shefa/core/constants/assets_app.dart';
import 'package:shefa/core/manager/app_state_manager.dart';
import '../../core/theme/color_app.dart';
import 'otp_screen.dart';

import '../../l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'LoginScreen';
  final Offset? revealOffset;
  const LoginScreen({super.key, this.revealOffset});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool isPhoneSelected = true;
  bool isPasswordVisible = false;

  late AnimationController _revealController;
  late Animation<double> _revealAnimation;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _revealAnimation = CurvedAnimation(
      parent: _revealController,
      curve: Curves.easeInOutExpo,
    );
    _revealController.forward();
  }

  @override
  void dispose() {
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: double.infinity,
      color: appStateManager.isDarkMode ? ColorApp.appDark : ColorApp.appLight,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 80),
              // اللوجو
              Center(child: Image.asset(AssetsApp.logo, height: 100)),
              const SizedBox(height: 40),
              Text(
                AppLocalizations.of(context)!.login,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: appStateManager.isDarkMode
                      ? ColorApp.appLight
                      : ColorApp.primary,
                ),
              ),
              const SizedBox(height: 30),

              // كارت تسجيل الدخول
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: appStateManager.isDarkMode
                      ? ColorApp.appLight
                      : ColorApp.icons,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    // منطقة التبديل (Tabs) مع البوردر الخارجي المطلب
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: ColorApp.primary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ColorApp.primary, width: 2),
                      ),
                      child: Row(
                        children: [
                          _buildTabButton(
                            AppLocalizations.of(context)!.email,
                            !isPhoneSelected,
                            () {
                              setState(() => isPhoneSelected = false);
                            },
                          ),
                          _buildTabButton(
                            AppLocalizations.of(context)!.phoneNumber,
                            isPhoneSelected,
                            () {
                              setState(() => isPhoneSelected = true);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // العرض الشرطي للحقول
                    if (isPhoneSelected) ...[
                      _buildPhoneInput(),
                    ] else ...[
                      _buildEmailInput(
                        AppLocalizations.of(context)!.emailAddress,
                      ),
                      const SizedBox(height: 15),
                      _buildPasswordInput(),
                    ],
                    const SizedBox(height: 15),

                    // هل نسيت كلمة المرور
                    if (!isPhoneSelected)
                      Align(
                        alignment: Alignment.centerRight, // يمين عشان الـ RTL
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            AppLocalizations.of(context)!.forgotPassword,
                            style: const TextStyle(
                              color: ColorApp.textFieldHighlight,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 15),

                    // زرار الإرسال أو التسجيل
                    _buildMainButton(
                      isPhoneSelected
                          ? AppLocalizations.of(context)!.sendCode
                          : AppLocalizations.of(context)!.signIn,
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

                    // النص السفلي لإنشاء الحساب
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.dontHaveAccount,
                          style: TextStyle(
                            color: appStateManager.isDarkMode
                                ? ColorApp.appDark
                                : ColorApp.appLight,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            AppLocalizations.of(context)!.createAccount,
                            style: TextStyle(
                              color: ColorApp.textFieldHighlight,
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
                    _socialIcon(AssetsApp.icGoogle),
                    const SizedBox(width: 15),
                    _socialIcon(AssetsApp.icApple),
                    const SizedBox(width: 15),
                    _socialIcon(AssetsApp.icFacebook),
                  ],
                ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: ColorApp.buttonDetails,
      body: Stack(
        children: [
          widget.revealOffset != null
              ? AnimatedBuilder(
                  animation: _revealAnimation,
                  builder: (context, child) {
                    return ClipPath(
                      clipper: _CircularRevealClipper(
                        revealPercent: _revealAnimation.value,
                        center: widget.revealOffset!,
                      ),
                      child: body,
                    );
                  },
                )
              : body,

          // Floating Switchers
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFloatingButton(
                  onTap: () => appStateManager.toggleLanguage(),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          appStateManager.isArabic ? 'EN' : 'AR',
                          key: ValueKey<bool>(appStateManager.isArabic),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: appStateManager.isDarkMode
                                ? ColorApp.appLight
                                : ColorApp.icons,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _buildFloatingButton(
                  onTap: () => appStateManager.toggleTheme(),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => RotationTransition(
                      turns: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    ),
                    child: Icon(
                      appStateManager.isDarkMode
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      key: ValueKey<bool>(appStateManager.isDarkMode),
                      color: appStateManager.isDarkMode
                          ? ColorApp.appLight
                          : ColorApp.icons,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton({
    required VoidCallback onTap,
    required Widget child,
  }) {
    return _PressableScale(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: ColorApp.appAmoled.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: ColorApp.appLight.withOpacity(.5)),
            ),
            child: Center(child: child),
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
            color: isSelected
                ? (appStateManager.isDarkMode
                      ? ColorApp.appDark
                      : ColorApp.appLight)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? (appStateManager.isDarkMode
                        ? ColorApp.appLight
                        : ColorApp.icons)
                  : ColorApp.appLight,
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
            border: Border.all(color: ColorApp.textFieldHighlight),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '+20 ▼',
            style: TextStyle(
              color: appStateManager.isDarkMode
                  ? ColorApp.icons
                  : ColorApp.appLight,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildTextField(
            hint: AppLocalizations.of(context)!.phoneNumber,
          ),
        ),
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
      style: const TextStyle(color: ColorApp.appLight),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.password,
        hintStyle: const TextStyle(color: ColorApp.locationText),
        suffixIcon: IconButton(
          // تم تغييرها لـ suffix عشان الـ RTL
          icon: Icon(
            isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off_outlined,
            color: ColorApp.locationText,
          ),
          onPressed: () =>
              setState(() => isPasswordVisible = !isPasswordVisible),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorApp.textFieldHighlight),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorApp.textFieldHighlight),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // حقل إدخال عام
  Widget _buildTextField({required String hint}) {
    return TextField(
      style: TextStyle(
        color: appStateManager.isDarkMode
            ? ColorApp.appDark
            : ColorApp.appLight,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: ColorApp.locationText),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorApp.textFieldHighlight),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorApp.textFieldHighlight),
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
          backgroundColor: ColorApp.textFieldHighlight,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: appStateManager.isDarkMode
                ? ColorApp.appLight
                : ColorApp.appDark,
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

class _CircularRevealClipper extends CustomClipper<Path> {
  final double revealPercent;
  final Offset center;

  _CircularRevealClipper({required this.revealPercent, required this.center});

  @override
  Path getClip(Size size) {
    final path = Path();
    final double maxRadius = size.longestSide * 1.5;
    final double radius = maxRadius * revealPercent;
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    return path;
  }

  @override
  bool shouldReclip(covariant _CircularRevealClipper oldClipper) {
    return oldClipper.revealPercent != revealPercent;
  }
}

class _PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _PressableScale({required this.child, required this.onTap});

  @override
  State<_PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<_PressableScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}
