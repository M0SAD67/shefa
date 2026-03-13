import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'home_screen.dart';
import '../nurseries/nurseries_screen.dart';
import '../icu/icu_screen.dart';
import '../bookings/bookings_screen.dart';
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
    const IcuScreen(),
    const BookingsScreen(),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppLocalizations.of(context)!.navHome,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.child_care),
            label: AppLocalizations.of(context)!.navNurseries,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: AppLocalizations.of(context)!.navIcu,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: AppLocalizations.of(context)!.navBookings,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppLocalizations.of(context)!.navAccount,
          ),
        ],
      ),
    );
  }
}
