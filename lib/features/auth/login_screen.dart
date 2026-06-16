import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
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
import 'package:intl_phone_field/intl_phone_field.dart';
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
  String _selectedGender = 'male';
  String _completePhoneNumber = '';
  int _phoneLength = 0;
  File? _verificationDocument;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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
    _phoneController.dispose();
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
                      // ── Role Selector (Signup only) ──
                      if (isSignupMode) ...[
                        _buildRoleSelector(),
                        const SizedBox(height: 15),
                      ],

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
                      if (isSignupMode) ...[
                        _buildGenderSelector(),
                        const SizedBox(height: 15),
                      ],

                      _buildEmailInput(
                        AppLocalizations.of(context)!.emailAddress,
                      ),
                      const SizedBox(height: 15),

                      if (isSignupMode) ...[
                        _buildPhoneInput(),
                        const SizedBox(height: 15),
                      ],

                      _buildPasswordInput(),

                      if (isSignupMode) ...[
                        const SizedBox(height: 15),
                        _buildConfirmPasswordInput(),
                        if (isMedicalStaffSelected) ...[
                          const SizedBox(height: 15),
                          _buildDocumentUploadButton(),
                        ],
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
                                        phone: _completePhoneNumber,
                                        role: isMedicalStaffSelected ? 1 : 2,
                                        gender: _selectedGender == 'male'
                                            ? 1
                                            : 2,
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
                                            email: _emailController.text.trim(),
                                          ),
                                        ),
                                      );
                                    } else {
                                      // ── جزيئة الـ Login ومسح الأخطاء للتوجه لصفحة التفعيل ──
                                      try {
                                        final result = await authRepository
                                            .login(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                            );
                                        final token = result['data'] != null
                                            ? result['data']['access_token']
                                            : result['access_token'];

                                        if (token != null) {
                                          await appStateManager.clearUserData();
                                          await CacheHelper.saveData(
                                            key: 'token',
                                            value: token,
                                          );
                                          await CacheHelper.saveData(
                                            key: 'email',
                                            value: _emailController.text,
                                          );

                                          int detectedRole =
                                              0; // default: patient
                                          final payload = _decodeJwt(token);
                                          if (payload != null) {
                                            final aud = payload['aud'];
                                            if (aud is List) {
                                              if (aud.contains(2) ||
                                                  aud.contains('2')) {
                                                detectedRole = 1; // Hospital
                                              }
                                            } else if (aud != null) {
                                              final audStr = aud.toString();
                                              if (audStr == '2' ||
                                                  audStr.contains('2')) {
                                                detectedRole = 1;
                                              }
                                            }
                                          }

                                          appStateManager.setUserRole(
                                            detectedRole,
                                          );
                                          appStateManager.setUserProfile(
                                            email: _emailController.text,
                                          );

                                          try {
                                            final profileResult =
                                                await authRepository
                                                    .getUserProfile(token);
                                            final userData =
                                                profileResult['data'] != null
                                                ? profileResult['data']['account']
                                                : profileResult['account'];
                                            if (userData != null) {
                                              final rawRole = userData['role'];
                                              final int role = rawRole is int
                                                  ? rawRole
                                                  : int.tryParse(
                                                          rawRole?.toString() ??
                                                              '',
                                                        ) ??
                                                        0;
                                              final mappedRole = role == 1
                                                  ? 1
                                                  : 0;
                                              appStateManager.setUserRole(
                                                mappedRole,
                                              );

                                              final String name =
                                                  userData['username'] ??
                                                  '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'
                                                      .trim();
                                              appStateManager.setUserProfile(
                                                name: name.isNotEmpty
                                                    ? name
                                                    : null,
                                                email: userData['email'],
                                                phone: userData['phone'],
                                                address: userData['address'],
                                                profileImage:
                                                    userData['profilePicture'] ??
                                                    userData['avatar'] ??
                                                    userData['image'] ??
                                                    userData['photo'],
                                              );

                                              if (mappedRole == 1) {
                                                await appStateManager
                                                    .fetchHospitalData(
                                                      token,
                                                      name,
                                                    );
                                                await appStateManager
                                                    .fetchBookings();
                                              } else {
                                                await appStateManager
                                                    .fetchPatientBookings();
                                              }
                                            }
                                          } catch (profileError) {
                                            debugPrint(
                                              'Error fetching user profile: $profileError',
                                            );
                                            if (detectedRole == 1) {
                                              await appStateManager
                                                  .fetchHospitalData(token, "");
                                              await appStateManager
                                                  .fetchBookings();
                                            } else {
                                              await appStateManager
                                                  .fetchPatientBookings();
                                            }
                                          }

                                          if (!context.mounted) return;
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            loginSuccessToMainShellRoute(),
                                            (route) => false,
                                          );
                                        }
                                      } catch (loginError) {
                                        if (!context.mounted) return;
                                        final errorStr = loginError
                                            .toString()
                                            .toLowerCase();

                                        // إذا كان الحساب غير مفعل ويرجع الـ Backend خطأ 404 أو كلمة الـ Validation المحددة
                                        if (errorStr.contains(
                                              'invalid email or password',
                                            ) ||
                                            errorStr.contains('404')) {
                                          showCustomSnackBar(
                                            context,
                                            message:
                                                "الحساب قد يكون غير مفعّل، جاري الانتقال لصفحة التأكيد...",
                                            backgroundColor: Colors.orange,
                                            top: true,
                                          );

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => OtpScreen(
                                                email: _emailController.text
                                                    .trim(),
                                              ),
                                            ),
                                          );
                                          return; // إيقاف التنفيذ هنا حتى لا يظهر الـ error snackbar الرئيسي
                                        }

                                        // إعادة رمي الخطأ ليتم معالجته في الـ catch الخارجي في حال لم يكن 404
                                        rethrow;
                                      }
                                    }
                                  } catch (e) {
                                    if (!context.mounted) return;
                                    final l10n = AppLocalizations.of(context)!;

                                    final emailText = _emailController.text
                                        .trim()
                                        .toLowerCase();
                                    if (emailText.contains('hospital') ||
                                        emailText.contains('patient')) {
                                      final isHospitalUser = emailText.contains(
                                        'hospital',
                                      );
                                      await CacheHelper.saveData(
                                        key: 'token',
                                        value: isHospitalUser
                                            ? 'mock_hospital_token'
                                            : 'mock_patient_token',
                                      );
                                      appStateManager.setUserRole(
                                        isHospitalUser ? 1 : 2,
                                      );
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        loginSuccessToMainShellRoute(),
                                        (route) => false,
                                      );
                                      return;
                                    }

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

  // ══════════════════════════════════════════════
  //  Role Segmented Control
  // ══════════════════════════════════════════════

  Widget _buildRoleSelector() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ColorApp.textFieldHighlight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: ColorApp.textFieldHighlight.withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          _buildRoleOption(
            label: l10n.patient,
            icon: Icons.person_rounded,
            isSelected: !isMedicalStaffSelected,
            onTap: () => setState(() {
              isMedicalStaffSelected = false;
              _verificationDocument = null;
            }),
          ),
          _buildRoleOption(
            label: l10n.medicalStaff,
            icon: Icons.medical_services_rounded,
            isSelected: isMedicalStaffSelected,
            onTap: () => setState(() => isMedicalStaffSelected = true),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleOption({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? ColorApp.textFieldHighlight
                : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: ColorApp.textFieldHighlight.withOpacity(0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : ColorApp.locationText,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : ColorApp.locationText,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════
  //  Shared Widgets
  // ══════════════════════════════════════════════

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
    return Text(
      isSignupMode ? l10n.createAccount : l10n.login,
      key: ValueKey<bool>(isSignupMode),
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: appStateManager.isDarkMode
            ? ColorApp.appLight
            : ColorApp.primary,
      ),
    );
  }

  Widget _buildEmailInput(String hint) {
    return _buildTextField(
      hint: hint,
      controller: _emailController,
      validator: (value) => AppValidator.validateEmail(value, context),
    );
  }

  Widget _buildPhoneInput() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IntlPhoneField(
          controller: _phoneController,
          dropdownIconPosition: IconPosition.trailing,
          autovalidateMode: AutovalidateMode.disabled,
          disableLengthCheck: false,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.phoneNumber,
            labelStyle: const TextStyle(color: ColorApp.locationText),
            floatingLabelStyle: const TextStyle(
              color: ColorApp.textFieldHighlight,
            ),
            counterText: "",
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
          initialCountryCode: 'EG',
          languageCode: appStateManager.isArabic ? 'ar' : 'en',
          onChanged: (phone) {
            setState(() {
              _phoneLength = phone.number.length;
              _completePhoneNumber = phone.completeNumber;
            });
          },
          style: TextStyle(
            color: appStateManager.isDarkMode
                ? ColorApp.appDark
                : ColorApp.appLight,
          ),
          dropdownTextStyle: TextStyle(
            color: appStateManager.isDarkMode
                ? ColorApp.appDark
                : ColorApp.appLight,
          ),
        ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          end: 12,
          top: -8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            color: appStateManager.isDarkMode
                ? ColorApp.appLight
                : ColorApp.icons,
            child: Text(
              '$_phoneLength',
              style: const TextStyle(
                color: ColorApp.textFieldHighlight,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
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

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
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

  Widget _buildGenderSelector() {
    final l10n = AppLocalizations.of(context)!;
    final bool isDark = appStateManager.isDarkMode;
    final Color textColor = isDark ? ColorApp.appDark : ColorApp.appLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Icon(Icons.wc_rounded, color: ColorApp.textFieldHighlight, size: 22),
          const SizedBox(width: 8),
          Text(
            l10n.gender,
            style: TextStyle(
              color: ColorApp.locationText,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          _buildGenderOption(
            label: l10n.male,
            isSelected: _selectedGender == 'male',
            onTap: () {
              setState(() => _selectedGender = 'male');
              appStateManager.setGender('male');
            },
            textColor: textColor,
          ),
          const SizedBox(width: 20),
          _buildGenderOption(
            label: l10n.female,
            isSelected: _selectedGender == 'female',
            onTap: () {
              setState(() => _selectedGender = 'female');
              appStateManager.setGender('female');
            },
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? ColorApp.textFieldHighlight
                    : ColorApp.locationText.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isSelected ? 10 : 0,
                height: isSelected ? 10 : 0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorApp.textFieldHighlight,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? ColorApp.textFieldHighlight : textColor,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentUploadButton() {
    final l10n = AppLocalizations.of(context)!;
    final bool isDark = appStateManager.isDarkMode;
    final bool hasDoc = _verificationDocument != null;

    return GestureDetector(
      onTap: () async {
        try {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'webp'],
          );

          if (result != null && result.files.single.path != null) {
            setState(() {
              _verificationDocument = File(result.files.single.path!);
            });
            if (mounted) {
              showCustomSnackBar(
                context,
                message: l10n.documentUploaded,
                icon: Icons.check_circle_outline,
                backgroundColor: Colors.green,
                top: true,
              );
            }
          }
        } catch (e) {
          if (mounted) {
            showCustomSnackBar(
              context,
              message: l10n.unexpectedError,
              icon: Icons.error_outline,
              backgroundColor: Colors.red,
              top: true,
            );
          }
        }
      },
      child: Stack(
        children: [
          CustomPaint(
            painter: _DashedPainter(
              color: hasDoc
                  ? Colors.green.withOpacity(0.8)
                  : ColorApp.textFieldHighlight.withOpacity(0.6),
              borderRadius: 20,
              strokeWidth: 2,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: hasDoc
                    ? Colors.green.withOpacity(isDark ? 0.15 : 0.08)
                    : ColorApp.textFieldHighlight.withOpacity(
                        isDark ? 0.15 : 0.08,
                      ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: hasDoc
                          ? Colors.green.withOpacity(0.2)
                          : ColorApp.textFieldHighlight.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      hasDoc
                          ? Icons.verified_rounded
                          : Icons.cloud_upload_outlined,
                      color: hasDoc
                          ? Colors.green
                          : ColorApp.textFieldHighlight,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    hasDoc ? l10n.documentUploaded : l10n.uploadVerificationDoc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? ColorApp.appDark : ColorApp.appLight,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!hasDoc)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "PDF, PNG, JPG, WEBP (Max 5MB)",
                        style: TextStyle(
                          color: isDark
                              ? ColorApp.appAmoled
                              : ColorApp.locationText,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  if (hasDoc) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.black : Colors.white)
                            .withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.description_outlined,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              _verificationDocument!.path.split('/').last,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black87,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (hasDoc)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _verificationDocument = null;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
//  Helper Classes
// ══════════════════════════════════════════════

class _DashedPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  _DashedPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashWidth = 5,
    this.dashSpace = 3,
    this.borderRadius = 20,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromLTRBR(
          0,
          0,
          size.width,
          size.height,
          Radius.circular(borderRadius),
        ),
      );

    final dashPath = Path();
    double distance = 0;
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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

Map<String, dynamic>? _decodeJwt(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    final resp = utf8.decode(base64Url.decode(normalized));
    return json.decode(resp) as Map<String, dynamic>;
  } catch (e) {
    debugPrint('Error decoding JWT: $e');
    return null;
  }
}
