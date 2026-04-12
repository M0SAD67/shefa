import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shefa/core/constants/assets_app.dart';
import 'package:shefa/core/manager/app_state_manager.dart';
import 'package:shefa/features/home/main_shell.dart';
import 'package:shefa/core/utils/app_validator.dart';
import 'package:shefa/core/utils/auth_error_ui_message.dart';
import 'package:shefa/core/widgets/custom_snackbar.dart';
import 'package:shefa/core/cache/cache_helper.dart';
import 'package:shefa/features/auth/auth_repository.dart';
import '../../core/theme/color_app.dart';
import 'otp_screen.dart';
import '../../l10n/app_localizations.dart';
import 'package:country_flags/country_flags.dart';

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
  bool isConfirmPasswordVisible = false;
  bool isSignupMode = false;
  bool _isLoading = false;

  //  متغيرات اختيار الدولة
  String _selectedCountryCode = '+20';
  String _selectedIsoCode = 'EG';

  //  قائمة الدول
  final List<Map<String, String>> _countries = [
    {'code': '+20', 'nameAr': 'مصر', 'nameEn': 'Egypt', 'isoCode': 'EG'},
    {
      'code': '+966',
      'nameAr': 'السعودية',
      'nameEn': 'Saudi Arabia',
      'isoCode': 'SA',
    },
    {'code': '+971', 'nameAr': 'الإمارات', 'nameEn': 'UAE', 'isoCode': 'AE'},
    {'code': '+965', 'nameAr': 'الكويت', 'nameEn': 'Kuwait', 'isoCode': 'KW'},
    {'code': '+974', 'nameAr': 'قطر', 'nameEn': 'Qatar', 'isoCode': 'QA'},
    {'code': '+973', 'nameAr': 'البحرين', 'nameEn': 'Bahrain', 'isoCode': 'BH'},
    {'code': '+968', 'nameAr': 'عمان', 'nameEn': 'Oman', 'isoCode': 'OM'},
    {'code': '+962', 'nameAr': 'الأردن', 'nameEn': 'Jordan', 'isoCode': 'JO'},
    {
      'code': '+970',
      'nameAr': 'فلسطين',
      'nameEn': 'Palestine',
      'isoCode': 'PS',
    },
    {'code': '+961', 'nameAr': 'لبنان', 'nameEn': 'Lebanon', 'isoCode': 'LB'},
    {'code': '+964', 'nameAr': 'العراق', 'nameEn': 'Iraq', 'isoCode': 'IQ'},
    {'code': '+967', 'nameAr': 'اليمن', 'nameEn': 'Yemen', 'isoCode': 'YE'},
    {'code': '+963', 'nameAr': 'سوريا', 'nameEn': 'Syria', 'isoCode': 'SY'},
    {'code': '+249', 'nameAr': 'السودان', 'nameEn': 'Sudan', 'isoCode': 'SD'},
    {'code': '+218', 'nameAr': 'ليبيا', 'nameEn': 'Libya', 'isoCode': 'LY'},
    {'code': '+213', 'nameAr': 'الجزائر', 'nameEn': 'Algeria', 'isoCode': 'DZ'},
    {'code': '+216', 'nameAr': 'تونس', 'nameEn': 'Tunisia', 'isoCode': 'TN'},
    {'code': '+212', 'nameAr': 'المغرب', 'nameEn': 'Morocco', 'isoCode': 'MA'},
    {
      'code': '+222',
      'nameAr': 'موريتانيا',
      'nameEn': 'Mauritania',
      'isoCode': 'MR',
    },
    {'code': '+253', 'nameAr': 'جيبوتي', 'nameEn': 'Djibouti', 'isoCode': 'DJ'},
    {'code': '+252', 'nameAr': 'الصومال', 'nameEn': 'Somalia', 'isoCode': 'SO'},
    {
      'code': '+269',
      'nameAr': 'جزر القمر',
      'nameEn': 'Comoros',
      'isoCode': 'KM',
    },
    {
      'code': '+211',
      'nameAr': 'جنوب السودان',
      'nameEn': 'South Sudan',
      'isoCode': 'SS',
    },
    {'code': '+90', 'nameAr': 'تركيا', 'nameEn': 'Turkey', 'isoCode': 'TR'},
    {'code': '+1', 'nameAr': 'أمريكا', 'nameEn': 'USA', 'isoCode': 'US'},
    {'code': '+1', 'nameAr': 'كندا', 'nameEn': 'Canada', 'isoCode': 'CA'},
    {'code': '+44', 'nameAr': 'بريطانيا', 'nameEn': 'UK', 'isoCode': 'GB'},
    {'code': '+49', 'nameAr': 'ألمانيا', 'nameEn': 'Germany', 'isoCode': 'DE'},
    {'code': '+33', 'nameAr': 'فرنسا', 'nameEn': 'France', 'isoCode': 'FR'},
    {'code': '+34', 'nameAr': 'إسبانيا', 'nameEn': 'Spain', 'isoCode': 'ES'},
    {'code': '+39', 'nameAr': 'إيطاليا', 'nameEn': 'Italy', 'isoCode': 'IT'},
    {
      'code': '+61',
      'nameAr': 'أستراليا',
      'nameEn': 'Australia',
      'isoCode': 'AU',
    },
    {'code': '+81', 'nameAr': 'اليابان', 'nameEn': 'Japan', 'isoCode': 'JP'},
    {
      'code': '+82',
      'nameAr': 'كوريا الجنوبية',
      'nameEn': 'South Korea',
      'isoCode': 'KR',
    },
    {'code': '+86', 'nameAr': 'الصين', 'nameEn': 'China', 'isoCode': 'CN'},
    {'code': '+91', 'nameAr': 'الهند', 'nameEn': 'India', 'isoCode': 'IN'},
    {'code': '+7', 'nameAr': 'روسيا', 'nameEn': 'Russia', 'isoCode': 'RU'},
    {'code': '+55', 'nameAr': 'البرازيل', 'nameEn': 'Brazil', 'isoCode': 'BR'},
    {
      'code': '+31',
      'nameAr': 'هولندا',
      'nameEn': 'Netherlands',
      'isoCode': 'NL',
    },
    {'code': '+32', 'nameAr': 'بلجيكا', 'nameEn': 'Belgium', 'isoCode': 'BE'},
    {
      'code': '+41',
      'nameAr': 'سويسرا',
      'nameEn': 'Switzerland',
      'isoCode': 'CH',
    },
    {'code': '+43', 'nameAr': 'النمسا', 'nameEn': 'Austria', 'isoCode': 'AT'},
    {'code': '+46', 'nameAr': 'السويد', 'nameEn': 'Sweden', 'isoCode': 'SE'},
    {'code': '+47', 'nameAr': 'النرويج', 'nameEn': 'Norway', 'isoCode': 'NO'},
    {'code': '+45', 'nameAr': 'الدنمارك', 'nameEn': 'Denmark', 'isoCode': 'DK'},
    {
      'code': '+351',
      'nameAr': 'البرتغال',
      'nameEn': 'Portugal',
      'isoCode': 'PT',
    },
    {'code': '+30', 'nameAr': 'اليونان', 'nameEn': 'Greece', 'isoCode': 'GR'},
    {'code': '+60', 'nameAr': 'ماليزيا', 'nameEn': 'Malaysia', 'isoCode': 'MY'},
    {
      'code': '+62',
      'nameAr': 'إندونيسيا',
      'nameEn': 'Indonesia',
      'isoCode': 'ID',
    },
    {'code': '+66', 'nameAr': 'تايلاند', 'nameEn': 'Thailand', 'isoCode': 'TH'},
    {'code': '+234', 'nameAr': 'نيجيريا', 'nameEn': 'Nigeria', 'isoCode': 'NG'},
    {
      'code': '+27',
      'nameAr': 'جنوب أفريقيا',
      'nameEn': 'South Africa',
      'isoCode': 'ZA',
    },
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  late AnimationController _revealController;
  late Animation<double> _revealAnimation;

  String _t(String ar, String en) {
    return appStateManager.isArabic ? ar : en;
  }

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
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  //  دالة عرض قائمة الدول
  void _showCountryPicker() {
    String searchQuery = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: appStateManager.isDarkMode
          ? ColorApp.appDark
          : ColorApp.appLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredCountries = _countries.where((country) {
              final nameAr = (country['nameAr'] ?? '').toLowerCase();
              final nameEn = (country['nameEn'] ?? '').toLowerCase();
              final code = (country['code'] ?? '').toLowerCase();
              final query = searchQuery.toLowerCase();
              return nameAr.contains(query) ||
                  nameEn.contains(query) ||
                  code.contains(query);
            }).toList();

            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        onChanged: (value) {
                          setModalState(() {
                            searchQuery = value;
                          });
                        },
                        style: TextStyle(
                          color: appStateManager.isDarkMode
                              ? ColorApp.appLight
                              : ColorApp.appDark,
                        ),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.searchCountry,
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: appStateManager.isDarkMode
                              ? Colors.grey[850]
                              : Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: filteredCountries.length,
                        itemBuilder: (context, index) {
                          final country = filteredCountries[index];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: SizedBox(
                                width: 36,
                                height: 26,
                                child: CountryFlag.fromCountryCode(
                                  country['isoCode']!,
                                ),
                              ),
                            ),
                            title: Text(
                              _t(
                                country['nameAr'] ?? '',
                                country['nameEn'] ?? '',
                              ),
                              style: TextStyle(
                                color: appStateManager.isDarkMode
                                    ? ColorApp.appLight
                                    : ColorApp.appDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Text(
                              country['code'] ?? '',
                              style: TextStyle(
                                color: ColorApp.textFieldHighlight,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedCountryCode = country['code'] ?? '+20';
                                _selectedIsoCode = country['isoCode'] ?? 'EG';
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
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
                  child: Text(
                    isSignupMode
                        ? AppLocalizations.of(context)!.createAccount
                        : AppLocalizations.of(context)!.login,
                    key: ValueKey<bool>(isSignupMode),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: appStateManager.isDarkMode
                          ? ColorApp.appLight
                          : ColorApp.primary,
                    ),
                  ),
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
                      // Tab Switcher
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
                              () => setState(() => isPhoneSelected = false),
                            ),
                            _buildTabButton(
                              AppLocalizations.of(context)!.phoneNumber,
                              isPhoneSelected,
                              () => setState(() => isPhoneSelected = true),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Fields
                      if (isSignupMode) ...[
                        _buildTextField(
                          hint: AppLocalizations.of(context)!.username,
                          controller: _usernameController,
                          validator: (value) => value == null || value.isEmpty
                              ? AppLocalizations.of(context)!.validationError
                              : null,
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          hint: AppLocalizations.of(context)!.address,
                          controller: _addressController,
                          validator: (value) => value == null || value.isEmpty
                              ? AppLocalizations.of(context)!.validationError
                              : null,
                        ),
                        const SizedBox(height: 15),
                      ],

                      if (isPhoneSelected)
                        _buildPhoneInput()
                      else ...[
                        _buildEmailInput(
                          AppLocalizations.of(context)!.emailAddress,
                        ),
                        const SizedBox(height: 15),
                        _buildPasswordInput(),
                      ],

                      if (isSignupMode) ...[
                        const SizedBox(height: 15),
                        _buildConfirmPasswordInput(),
                      ],

                      if (!isPhoneSelected && !isSignupMode)
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
                        isPhoneSelected
                            ? AppLocalizations.of(context)!.sendCode
                            : isSignupMode
                            ? AppLocalizations.of(context)!.createAccount
                            : AppLocalizations.of(context)!.signIn,
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
                                        phone:
                                            _selectedCountryCode +
                                            _phoneController.text,
                                        username: _usernameController.text,
                                        address: _addressController.text,
                                      );
                                      if (!context.mounted) return;
                                      final l10nSignup =
                                          AppLocalizations.of(context)!;
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
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MainShell(),
                                          ),
                                          (route) => false,
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    if (!context.mounted) return;
                                    final l10n =
                                        AppLocalizations.of(context)!;
                                    showCustomSnackBar(
                                      context,
                                      message: authErrorSnackMessage(
                                        e,
                                        l10n,
                                      ),
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
                if (!isPhoneSelected && !isSignupMode)
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

  //  حقل التليفون مع اختيار الدولة
  Widget _buildPhoneInput() {
    return Row(
      children: [
        GestureDetector(
          onTap: _showCountryPicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              border: Border.all(color: ColorApp.textFieldHighlight),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    width: 28,
                    height: 20,
                    child: CountryFlag.fromCountryCode(_selectedIsoCode),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  _selectedCountryCode,
                  style: TextStyle(
                    color: appStateManager.isDarkMode
                        ? ColorApp.icons
                        : ColorApp.appLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_drop_down,
                  color: appStateManager.isDarkMode
                      ? ColorApp.icons
                      : ColorApp.appLight,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildTextField(
            hint: AppLocalizations.of(context)!.phoneNumber,
            controller: _phoneController,
            validator: (value) => AppValidator.validatePhone(value, context),
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
