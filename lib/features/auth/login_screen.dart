import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shefa/core/constants/assets_app.dart';
import 'package:shefa/core/manager/app_state_manager.dart';
import 'package:shefa/core/utils/app_validator.dart';
import 'package:shefa/core/utils/auth_error_ui_message.dart';
import 'package:shefa/core/widgets/custom_snackbar.dart';
import 'package:shefa/core/cache/cache_helper.dart';
import 'package:shefa/core/navigation/main_shell_route.dart';
import 'package:shefa/features/auth/auth_repository.dart';
import '../../core/theme/color_app.dart';
import 'otp_screen.dart';
import 'package:shefa/core/widgets/shefa_branded_text_loader.dart';
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
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isSignupMode = false;
  bool _isLoading = false;
  bool isMedicalStaffSelected = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

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
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    _addressController.dispose();
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 80),
                Center(child: Image.asset(AssetsApp.logo, height: 100)),
                const SizedBox(height: 40),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildHeader(),
                ),

                const SizedBox(height: 30),

                // Card Container
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
                      // Fields
                      if (isSignupMode) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                hint: AppLocalizations.of(context)!.username,
                                controller: _usernameController,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? AppLocalizations.of(
                                        context,
                                      )!.validationError
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildTextField(
                                hint: AppLocalizations.of(context)!.address,
                                controller: _addressController,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? AppLocalizations.of(
                                        context,
                                      )!.validationError
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],

                      _buildEmailInput(
                        AppLocalizations.of(context)!.emailAddress,
                      ),
                      const SizedBox(height: 15),
                      _buildPasswordInput(),

                      if (isSignupMode) ...[
                        const SizedBox(height: 15),
                        _buildConfirmPasswordInput(),
                      ],

                      if (!isSignupMode)
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
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

                      const SizedBox(height: 25),

                      _buildMainButton(
                        isSignupMode
                            ? AppLocalizations.of(context)!.createAccount
                            : AppLocalizations.of(context)!.signIn,
                        isLoading: _isLoading,
                        onTap: _isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => _isLoading = true);
                                  try {
                                    if (isSignupMode) {
                                      await authRepository.signup(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        confirmPassword:
                                            _confirmPasswordController.text,
                                        username: _usernameController.text,
                                        address: _addressController.text,
                                        userType: isMedicalStaffSelected
                                            ? 'medical_staff'
                                            : 'patient',
                                      );
                                      if (!context.mounted) return;
                                      final l10nSignup = AppLocalizations.of(
                                        context,
                                      )!;
                                      showCustomSnackBar(
                                        context,
                                        message:
                                            l10nSignup.accountCreatedSuccess,
                                        backgroundColor: Colors.green,
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OtpScreen(
                                            email: _emailController.text,
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Login logic
                                      final result = await authRepository.login(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                      final token = result['data'] != null
                                          ? result['data']['access_token']
                                          : result['access_token'];

                                      if (token != null) {
                                        await CacheHelper.saveData(
                                          key: 'token',
                                          value: token,
                                        );
                                        if (!context.mounted) return;
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          loginSuccessToMainShellRoute(),
                                          (route) => false,
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    if (!context.mounted) return;
                                    final l10n = AppLocalizations.of(context)!;
                                    showCustomSnackBar(
                                      context,
                                      message: authErrorSnackMessage(e, l10n),
                                      backgroundColor: ColorApp.error,
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
                              },
                      ),

                      const SizedBox(height: 15),

                      // Toggle Login/Signup
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isSignupMode
                                ? AppLocalizations.of(
                                    context,
                                  )!.alreadyHaveAccount
                                : AppLocalizations.of(context)!.dontHaveAccount,
                            style: TextStyle(
                              color: appStateManager.isDarkMode
                                  ? ColorApp.appDark
                                  : ColorApp.appLight,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isSignupMode = !isSignupMode;
                              });
                            },
                            child: Text(
                              isSignupMode
                                  ? AppLocalizations.of(context)!.login
                                  : AppLocalizations.of(context)!.createAccount,
                              style: const TextStyle(
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

                // Social Icons
                if (!isSignupMode)
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
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );

    final stackBody = Stack(
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

        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFloatingButton(
                onTap: () {
                  appStateManager.toggleLanguage();
                  setState(() {});
                },
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
    );

    final route = ModalRoute.of(context);
    final Animation<double> secondary =
        route?.secondaryAnimation ?? const AlwaysStoppedAnimation<double>(0.0);

    final shellBody = AnimatedBuilder(
      animation: secondary,
      builder: (context, child) {
        final t = Curves.easeInOutCubic.transform(secondary.value);
        final isRtl = Directionality.of(context) == TextDirection.rtl;
        final sign = isRtl ? 1.0 : -1.0;
        final w = MediaQuery.sizeOf(context).width;
        return Transform.translate(
          offset: Offset(sign * w * 0.1 * t, 0),
          child: Transform.scale(
            scale: 1.0 - 0.07 * t,
            child: Opacity(
              opacity: (1.0 - 0.15 * t).clamp(0.0, 1.0),
              child: child!,
            ),
          ),
        );
      },
      child: stackBody,
    );

    return Scaffold(backgroundColor: ColorApp.buttonDetails, body: shellBody);
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

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context)!;
    if (!isSignupMode) {
      return Text(
        l10n.login,
        key: const ValueKey('login_title'),
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: appStateManager.isDarkMode
              ? ColorApp.appLight
              : ColorApp.primary,
        ),
      );
    }

    return Wrap(
      key: const ValueKey('signup_title'),
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          l10n.createAccountFor,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: appStateManager.isDarkMode
                ? ColorApp.appLight
                : ColorApp.appDark,
          ),
        ),
        GestureDetector(
          onTap: () =>
              setState(() => isMedicalStaffSelected = !isMedicalStaffSelected),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: Text(
              isMedicalStaffSelected ? l10n.medicalStaff : l10n.patient,
              key: ValueKey<bool>(isMedicalStaffSelected),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: ColorApp.textFieldHighlight,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.dashed,
                decorationThickness: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailInput(String hint) {
    return _buildTextField(
      hint: hint,
      controller: _emailController,
      validator: (value) => AppValidator.validateEmail(value, context),
    );
  }

  Widget _buildPasswordInput() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !isPasswordVisible,
      validator: (value) => AppValidator.validatePassword(value, context),
      style: TextStyle(
        color: appStateManager.isDarkMode
            ? ColorApp.appDark
            : ColorApp.appLight,
      ),
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.password,
        labelStyle: const TextStyle(color: ColorApp.locationText),
        floatingLabelStyle: const TextStyle(color: ColorApp.textFieldHighlight),
        suffixIcon: IconButton(
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
          borderSide: const BorderSide(
            color: ColorApp.textFieldHighlight,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordInput() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !isConfirmPasswordVisible,
      validator: (value) {
        if (value != _passwordController.text) {
          return AppLocalizations.of(context)!.passwordsDoNotMatch;
        }
        return null;
      },
      style: TextStyle(
        color: appStateManager.isDarkMode
            ? ColorApp.appDark
            : ColorApp.appLight,
      ),
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.confirmPassword,
        labelStyle: const TextStyle(color: ColorApp.locationText),
        floatingLabelStyle: const TextStyle(color: ColorApp.textFieldHighlight),
        suffixIcon: IconButton(
          icon: Icon(
            isConfirmPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off_outlined,
            color: ColorApp.locationText,
          ),
          onPressed: () => setState(
            () => isConfirmPasswordVisible = !isConfirmPasswordVisible,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorApp.textFieldHighlight),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorApp.textFieldHighlight,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // حقل إدخال عام
  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: TextStyle(
        color: appStateManager.isDarkMode
            ? ColorApp.appDark
            : ColorApp.appLight,
      ),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: const TextStyle(color: ColorApp.locationText),
        floatingLabelStyle: const TextStyle(color: ColorApp.textFieldHighlight),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorApp.textFieldHighlight),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorApp.textFieldHighlight,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildMainButton(
    String title, {
    bool isLoading = false,
    VoidCallback? onTap,
  }) {
    return Material(
      color: isLoading
          ? ColorApp.textFieldHighlight.withOpacity(0.5)
          : ColorApp.textFieldHighlight,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: isLoading ? null : (onTap ?? () {}),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: isLoading
              ? const Center(
                  child: ShefaBrandedTextLoader(
                    arabicFontSize: 20,
                    showDots: false,
                  ),
                )
              : Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: appStateManager.isDarkMode
                        ? ColorApp.appLight
                        : ColorApp.appDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

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
