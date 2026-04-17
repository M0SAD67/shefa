import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/color_app.dart';
import 'home_screen.dart';
import '../nurseries/nurseries_screen.dart';
import '../profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  static const String routeName = 'MainShell';
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const NurseriesScreen(),
    // const IcuScreen(),
    // const BookingsScreen(),
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
            Iconsax.hospital,
            color: _selectedIndex == 1 ? ColorApp.secondary : Colors.white,
          ),
          Icon(
            Iconsax.personalcard,
            color: _selectedIndex == 2 ? ColorApp.secondary : Colors.white,
          ),
        ],
      ),
    );
  }
}
