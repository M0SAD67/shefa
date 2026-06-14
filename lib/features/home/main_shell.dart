import 'dart:io';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/color_app.dart';
import '../../core/manager/app_state_manager.dart';
import '../bookings/booking_requests_screen.dart';
import 'home_screen.dart';
import '../profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  static const String routeName = 'MainShell';
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appStateManager.fetchUserProfile();
      appStateManager.fetchPatientBookings();
    });
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const BookingRequestsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Platform.isIOS
          ? _buildIOSTabBar()
          : _buildAndroidNavBar(),
    );
  }

  /// iOS: Liquid Glass Tab Bar using cupertino_native
  Widget _buildIOSTabBar() {
    return CNTabBar(
      items: const [
        CNTabBarItem(label: 'Home', icon: CNSymbol('house.fill')),
        CNTabBarItem(label: 'Requests', icon: CNSymbol('calendar.badge.clock')),
        CNTabBarItem(label: 'Profile', icon: CNSymbol('person.crop.circle')),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  /// Android: Curved Navigation Bar (original design)
  Widget _buildAndroidNavBar() {
    return CurvedNavigationBar(
      index: _selectedIndex,
      onTap: _onItemTapped,
      backgroundColor: Colors.transparent,
      color: ColorApp.appDark,
      buttonBackgroundColor: ColorApp.appDark,
      height: 60,
      items: [
        Icon(
          Iconsax.safe_home4,
          color: _selectedIndex == 0 ? ColorApp.secondary : Colors.white,
        ),
        Icon(
          Iconsax.hospital,
          color: _selectedIndex == 1 ? ColorApp.secondary : Colors.white,
        ),
        Icon(
          Iconsax.personalcard,
          color: _selectedIndex == 2 ? ColorApp.secondary : Colors.white,
        ),
      ],
    );
  }
}
