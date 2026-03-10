import 'package:flutter/material.dart';
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(
            icon: Icon(Icons.child_care),
            label: 'حضانات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'عناية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'الحجوزات',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}
