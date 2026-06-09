import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
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
      ),
    );
  }
}
