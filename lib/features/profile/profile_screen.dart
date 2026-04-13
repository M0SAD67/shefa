import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shefa/core/manager/app_state_manager.dart';
import 'package:shefa/core/theme/color_app.dart';
import 'package:shefa/l10n/app_localizations.dart';
import 'package:shefa/core/constants/assets_app.dart';
import 'package:shefa/features/profile/loading_ring_preview_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = 'ProfileScreen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController(
    text: "علي عماد",
  );
  final TextEditingController _addressController = TextEditingController(
    text: "الفلل بنها القليوبيه",
  );
  final TextEditingController _phoneController = TextEditingController(
    text: "01020304050",
  );
  final TextEditingController _emailController = TextEditingController(
    text: "aliemad@gmail.com",
  );
  final TextEditingController _passwordController = TextEditingController(
    text: "********",
  );

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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
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
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorApp.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
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
            fontSize: 13,
            color: isDark ? Colors.white70 : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: TextStyle(color: textColor, fontSize: 15),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: ColorApp.primary, size: 20),
            filled: true,
            fillColor: fieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
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
          body: CustomScrollView(
            slivers: [
              // Animated Dynamic Header
              SliverAppBar(
                expandedHeight: 250,
                floating: false,
                pinned: true,
                backgroundColor: ColorApp.primary,
                elevation: 0,
                automaticallyImplyLeading: false,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(15),
                  ),
                ),
                flexibleSpace: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(15),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double currentHeight = constraints.maxHeight;
                      final double minHeight = kToolbarHeight + topPadding;
                      final double t =
                          ((currentHeight - minHeight) / (250 - minHeight))
                              .clamp(0.0, 1.0);

                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF0D47A1),
                              ColorApp.primary,
                              const Color(0xFF1976D2),
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Decorative Background Circles
                            Positioned(
                              top: -50,
                              right: -50,
                              child: Opacity(
                                opacity: 0.1,
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
                            // Avatar Animation
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
                                          radius: lerpDouble(18, 50, t)!,
                                          backgroundImage: AssetImage(
                                            AssetsApp.userAvatar,
                                          ),
                                        ),
                                      ),
                                      Opacity(
                                        opacity: t,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: ColorApp.textFieldHighlight,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Iconsax.edit,
                                            size: 16,
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
                                        fontSize: lerpDouble(16, 22, t)!,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
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
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem(
                            "5",
                            AppLocalizations.of(context)!.bookings,
                            isDark,
                          ),
                          _buildStatItem("12", AppLocalizations.of(context)!.reviews, isDark),
                          _buildStatItem(AppLocalizations.of(context)!.active, AppLocalizations.of(context)!.status, isDark),
                        ],
                      ),
                      const SizedBox(height: 30),
                      _buildSectionTitle(AppLocalizations.of(context)!.personalInformation, isDark),
                      _buildMenuItem(
                        icon: Iconsax.user_edit,
                        title: AppLocalizations.of(context)!.editProfileInformation,
                        subtitle: AppLocalizations.of(context)!.phoneEmailPassword,
                        color: cardColor,
                        textColor: textColor,
                        onTap: _showEditProfileSheet,
                      ),
                      const SizedBox(height: 20),
                      _buildSectionTitle(AppLocalizations.of(context)!.appSettings, isDark),
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
                        title: AppLocalizations.of(context)!.loadingRingPreviewMenu,
                        subtitle: AppLocalizations.of(context)!.loadingRingPreviewTitle,
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
                      const SizedBox(height: 20),
                      _buildSectionTitle(AppLocalizations.of(context)!.support, isDark),
                      _buildMenuItem(
                        icon: Iconsax.info_circle,
                        title: AppLocalizations.of(context)!.aboutShefa,
                        color: cardColor,
                        textColor: textColor,
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Iconsax.logout,
                        title: AppLocalizations.of(context)!.logout,
                        color: cardColor,
                        textColor: ColorApp.error,
                        showArrow: false,
                        onTap: () {},
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String value, String label, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? ColorApp.secondary : ColorApp.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white60 : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDark ? ColorApp.secondary : ColorApp.primary,
          letterSpacing: 1.2,
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
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.transparent, // Color is now handled by Material
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          leading: Icon(icon, color: textColor.withOpacity(0.7), size: 22),
          title: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: TextStyle(
                    color: textColor.withOpacity(0.5),
                    fontSize: 13,
                  ),
                )
              : null,
          trailing: showArrow
              ? Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: textColor.withOpacity(0.3),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildThemeToggle(bool isDark, Color color, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          leading: Icon(
            isDark ? Iconsax.moon : Iconsax.sun_1,
            color: textColor.withOpacity(0.7),
            size: 22,
          ),
          title: Text(
            isDark ? AppLocalizations.of(context)!.darkMode : AppLocalizations.of(context)!.lightMode,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          trailing: Switch(
            value: isDark,
            activeColor: ColorApp.textFieldHighlight,
            onChanged: (value) {
              appStateManager.toggleTheme();
            },
          ),
        ),
      ),
    );
  }
}
