import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shefa/core/manager/app_state_manager.dart';
import 'package:shefa/core/theme/color_app.dart';
import 'package:shefa/l10n/app_localizations.dart';
import 'package:shefa/core/constants/assets_app.dart';
import 'package:shefa/core/constants/routes_app.dart';
import 'package:shefa/features/profile/loading_ring_preview_screen.dart';
import 'package:shefa/core/cache/cache_helper.dart';
import 'package:shefa/features/auth/auth_repository.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = 'ProfileScreen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  final TextEditingController _passwordController = TextEditingController(
    text: "********",
  );

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: appStateManager.userName);
    _addressController = TextEditingController(
      text: appStateManager.userAddress,
    );
    _phoneController = TextEditingController(text: appStateManager.userPhone);
    _emailController = TextEditingController(text: appStateManager.userEmail);
    appStateManager.addListener(_onAppStateChanged);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _animController.forward();
  }

  void _onAppStateChanged() {
    if (mounted) {
      setState(() {
        _nameController.text = appStateManager.userName;
        _addressController.text = appStateManager.userAddress;
        _phoneController.text = appStateManager.userPhone;
        _emailController.text = appStateManager.userEmail;
      });
    }
  }

  @override
  void dispose() {
    appStateManager.removeListener(_onAppStateChanged);
    _animController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showEditProfileSheet() {
    final bool isDark = appStateManager.isDarkMode;
    final Color bgColor = isDark ? ColorApp.icons : Colors.white;
    final Color textColor = isDark ? Colors.white : ColorApp.icons;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 30),
              _buildEditField(Iconsax.user, "Name", _nameController, isDark),
              const SizedBox(height: 15),
              _buildEditField(
                Iconsax.call,
                "Phone Number",
                _phoneController,
                isDark,
              ),
              const SizedBox(height: 15),
              _buildEditField(Iconsax.sms, "Email", _emailController, isDark),
              const SizedBox(height: 15),
              _buildEditField(
                Iconsax.lock,
                "Password",
                _passwordController,
                isDark,
                isPassword: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  final token = CacheHelper.getData(key: 'token') as String?;
                  if (token != null &&
                      token != 'mock_hospital_token' &&
                      token != 'mock_patient_token') {
                    // Show loading dialog
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    try {
                      final nameParts = _nameController.text.trim().split(' ');
                      final firstName = nameParts.first;
                      final lastName = nameParts.length > 1
                          ? nameParts.sublist(1).join(' ')
                          : '';

                      // Update profile info on backend
                      await authRepository.updateProfile(
                        token: token,
                        firstName: firstName,
                        lastName: lastName,
                        phone: _phoneController.text,
                      );

                      // Update password if changed
                      if (_passwordController.text != "********" &&
                          _passwordController.text.isNotEmpty) {
                        await authRepository.updatePassword(
                          token: token,
                          password: _passwordController.text,
                        );
                      }

                      // Update local state
                      appStateManager.setUserProfile(
                        name: _nameController.text,
                        email: _emailController.text,
                        phone: _phoneController.text,
                      );

                      if (context.mounted) {
                        Navigator.pop(context); // Pop loading dialog
                        Navigator.pop(context); // Pop sheet
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("تم حفظ التعديلات بنجاح"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        Navigator.pop(context); // Pop loading
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("فشل في حفظ التعديلات: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } else {
                    // For mock tokens, just update state locally
                    appStateManager.setUserProfile(
                      name: _nameController.text,
                      email: _emailController.text,
                      phone: _phoneController.text,
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorApp.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 5,
                  shadowColor: ColorApp.primary.withOpacity(0.5),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutAppDialog() {
    final bool isDark = appStateManager.isDarkMode;
    final Color bgColor = isDark ? ColorApp.icons : Colors.white;
    final Color textColor = isDark ? Colors.white : ColorApp.icons;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "About",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutBack)),
          child: FadeTransition(
            opacity: anim1,
            child: AlertDialog(
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              contentPadding: const EdgeInsets.all(24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: ColorApp.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(AssetsApp.logo, width: 80, height: 80),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Shefa App",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Version 1.0.0",
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Shefa is your comprehensive medical companion, connecting you seamlessly with trusted healthcare providers, nurseries, and medical staff.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: textColor.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorApp.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Close",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog() {
    final bool isDark = appStateManager.isDarkMode;
    final Color bgColor = isDark ? ColorApp.icons : Colors.white;
    final Color textColor = isDark ? Colors.white : ColorApp.icons;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Logout",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutBack)),
          child: FadeTransition(
            opacity: anim1,
            child: AlertDialog(
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ColorApp.error.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.logout,
                      color: ColorApp.error,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context)!.logout,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Text(
                "Are you sure you want to log out of your account?",
                style: TextStyle(
                  color: textColor.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              actionsPadding: const EdgeInsets.only(
                bottom: 16,
                right: 16,
                left: 16,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: textColor.withOpacity(0.6),
                  ),
                  child: const Text("Cancel", style: TextStyle(fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      RoutesApp.login,
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorApp.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEditField(
    IconData icon,
    String label,
    TextEditingController controller,
    bool isDark, {
    bool isPassword = false,
  }) {
    final Color fieldBg = isDark
        ? ColorApp.primary.withOpacity(0.1)
        : Colors.grey[100]!;
    final Color textColor = isDark ? Colors.white : ColorApp.icons;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white70 : Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: TextStyle(color: textColor, fontSize: 16),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: ColorApp.primary, size: 22),
            filled: true,
            fillColor: fieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appStateManager,
      builder: (context, child) {
        final bool isDark = appStateManager.isDarkMode;
        final Color cardColor = isDark ? ColorApp.icons : Colors.white;
        final Color textColor = isDark ? Colors.white : ColorApp.icons;
        final double topPadding = MediaQuery.of(context).padding.top;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              slivers: [
                // Animated Dynamic Header
                SliverAppBar(
                  expandedHeight: 280,
                  floating: false,
                  pinned: true,
                  backgroundColor: ColorApp.primary,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  flexibleSpace: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double currentHeight = constraints.maxHeight;
                        final double minHeight = kToolbarHeight + topPadding;
                        final double t =
                            ((currentHeight - minHeight) / (280 - minHeight))
                                .clamp(0.0, 1.0);

                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                ColorApp.primary.withOpacity(0.8),
                                ColorApp.primary,
                                ColorApp.secondary,
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Decorative Background Circles
                              Positioned(
                                top: -50 * t,
                                right: -50 * t,
                                child: Opacity(
                                  opacity: 0.1 * t,
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -30,
                                left: -20,
                                child: Opacity(
                                  opacity: 0.05,
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              // Glassmorphism Avatar Background
                              PositionedDirectional(
                                top: lerpDouble(topPadding + 5, 50, t)!,
                                start: lerpDouble(
                                  20,
                                  (MediaQuery.of(context).size.width / 2) - 55,
                                  t,
                                )!,
                                child: GestureDetector(
                                  onTap: _showEditProfileSheet,
                                  child: SizedBox(
                                    width: lerpDouble(40, 110, t)!,
                                    height: lerpDouble(40, 110, t)!,
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        CircleAvatar(
                                          radius: lerpDouble(20, 55, t)!,
                                          backgroundColor: Colors.white24,
                                          child: CircleAvatar(
                                            radius: lerpDouble(20, 55, t)!,
                                            backgroundColor: Colors.white24,
                                            child: CircleAvatar(
                                              radius: lerpDouble(18, 50, t)!,
                                              backgroundImage: AssetImage(
                                                appStateManager.isFemale
                                                    ? AssetsApp.userAvatarWomen
                                                    : AssetsApp.userAvatarMan,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Opacity(
                                          opacity: t,
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: ColorApp.secondary,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 5,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Iconsax.edit_2,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Name and Address Animation
                              PositionedDirectional(
                                top: lerpDouble(topPadding + 5, 175, t)!,
                                start: 0,
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                  padding: EdgeInsetsDirectional.only(
                                    start: lerpDouble(65, 0, t)!,
                                    end: 20,
                                  ),
                                  alignment: AlignmentDirectional(
                                    lerpDouble(-1.0, 0.0, t)!,
                                    0.0,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: t > 0.5
                                        ? CrossAxisAlignment.center
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _nameController.text,
                                        style: TextStyle(
                                          fontSize: lerpDouble(18, 26, t)!,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _addressController.text,
                                        style: TextStyle(
                                          fontSize: lerpDouble(11, 14, t)!,
                                          color: Colors.white70,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Profile Menu Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Glassmorphism Stats Container
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  isDark ? 0.2 : 0.05,
                                ),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem(
                                "5",
                                AppLocalizations.of(context)!.bookings,
                                isDark,
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              _buildStatItem(
                                "12",
                                AppLocalizations.of(context)!.reviews,
                                isDark,
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              _buildStatItem(
                                AppLocalizations.of(context)!.active,
                                AppLocalizations.of(context)!.status,
                                isDark,
                                isTextStat: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 35),

                        _buildSectionTitle(
                          AppLocalizations.of(context)!.personalInformation,
                          isDark,
                        ),
                        _buildMenuItem(
                          icon: Iconsax.user_edit,
                          title: AppLocalizations.of(
                            context,
                          )!.editProfileInformation,
                          subtitle: AppLocalizations.of(
                            context,
                          )!.phoneEmailPassword,
                          color: cardColor,
                          textColor: textColor,
                          onTap: _showEditProfileSheet,
                        ),
                        const SizedBox(height: 25),

                        _buildSectionTitle(
                          AppLocalizations.of(context)!.appSettings,
                          isDark,
                        ),
                        _buildThemeToggle(isDark, cardColor, textColor),
                        _buildMenuItem(
                          icon: Iconsax.global,
                          title: AppLocalizations.of(context)!.language,
                          subtitle: appStateManager.locale.languageCode == 'ar'
                              ? AppLocalizations.of(context)!.arabic
                              : AppLocalizations.of(context)!.english,
                          color: cardColor,
                          textColor: textColor,
                          onTap: () {
                            appStateManager.toggleLanguage();
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.timelapse_rounded,
                          title: AppLocalizations.of(
                            context,
                          )!.loadingRingPreviewMenu,
                          subtitle: AppLocalizations.of(
                            context,
                          )!.loadingRingPreviewTitle,
                          color: cardColor,
                          textColor: textColor,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) =>
                                    const LoadingRingPreviewScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 25),

                        _buildSectionTitle(
                          AppLocalizations.of(context)!.support,
                          isDark,
                        ),
                        _buildMenuItem(
                          icon: Iconsax.info_circle,
                          title: AppLocalizations.of(context)!.aboutShefa,
                          color: cardColor,
                          textColor: textColor,
                          onTap: _showAboutAppDialog,
                        ),
                        _buildMenuItem(
                          icon: Iconsax.logout,
                          title: AppLocalizations.of(context)!.logout,
                          color: cardColor,
                          textColor: ColorApp.error,
                          showArrow: false,
                          onTap: _showLogoutDialog,
                        ),

                        const SizedBox(height: 35),
                        _buildSectionTitle("Our Partners", isDark),
                        _buildPartnersSection(isDark),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPartnersSection(bool isDark) {
    final partners = [
      AssetsApp.partner1,
      AssetsApp.partner2,
      AssetsApp.partner3,
      AssetsApp.partner4,
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: partners.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 16),
            width: 140,
            decoration: BoxDecoration(
              color: isDark ? ColorApp.icons.withOpacity(0.5) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.grey.withOpacity(0.1),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(partners[index], fit: BoxFit.contain),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    bool isDark, {
    bool isTextStat = false,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: isTextStat ? 18 : 22,
            fontWeight: FontWeight.w900,
            color: isDark ? ColorApp.secondary : ColorApp.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white60 : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: isDark ? ColorApp.secondary : ColorApp.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required Color color,
    required Color textColor,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          highlightColor: ColorApp.primary.withOpacity(0.1),
          splashColor: ColorApp.primary.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: textColor == ColorApp.error
                        ? ColorApp.error.withOpacity(0.1)
                        : ColorApp.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: textColor == ColorApp.error
                        ? ColorApp.error
                        : ColorApp.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: textColor.withOpacity(0.5),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (showArrow)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: textColor.withOpacity(0.3),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle(bool isDark, Color color, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          highlightColor: ColorApp.primary.withOpacity(0.1),
          splashColor: ColorApp.primary.withOpacity(0.1),
          onTap: () {
            appStateManager.toggleTheme();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorApp.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isDark ? Iconsax.moon : Iconsax.sun_1,
                    color: ColorApp.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    isDark
                        ? AppLocalizations.of(context)!.darkMode
                        : AppLocalizations.of(context)!.lightMode,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                Switch.adaptive(
                  value: isDark,
                  activeColor: Colors.white,
                  activeTrackColor: ColorApp.secondary,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey.shade300,
                  onChanged: (value) {
                    appStateManager.toggleTheme();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
