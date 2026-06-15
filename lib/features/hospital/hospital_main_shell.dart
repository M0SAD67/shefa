import 'dart:io';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/color_app.dart';
import '../bookings/hospital_booking/hospital_booking.dart';
import '../profile/profile_screen.dart';
import 'hospital_booking_requests_screen.dart';
import 'hospital_home_screen.dart';

class HospitalMainShell extends StatefulWidget {
  static const String routeName = 'HospitalMainShell';
  const HospitalMainShell({super.key});

  @override
  State<HospitalMainShell> createState() => _HospitalMainShellState();
}

class _HospitalMainShellState extends State<HospitalMainShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HospitalHomeScreen(),
    const HospitalBookingRequestsSelectScreen(),
    const HospitalBookingsScreen(),
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
        CNTabBarItem(label: 'Home', icon: CNSymbol('house.fill', size: 20)),
        CNTabBarItem(
          label: 'Requests',
          icon: CNSymbol('doc.text.fill', size: 20),
        ),
        CNTabBarItem(
          label: 'Bookings',
          icon: CNSymbol('cross.case.fill', size: 20),
        ),
        CNTabBarItem(
          label: 'Profile',
          icon: CNSymbol('person.crop.circle', size: 20),
        ),
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
          Iconsax.document_text,
          color: _selectedIndex == 1 ? ColorApp.secondary : Colors.white,
        ),
        Icon(
          Iconsax.hospital,
          color: _selectedIndex == 2 ? ColorApp.secondary : Colors.white,
        ),
        Icon(
          Iconsax.personalcard,
          color: _selectedIndex == 3 ? ColorApp.secondary : Colors.white,
        ),
      ],
    );
  }
}
