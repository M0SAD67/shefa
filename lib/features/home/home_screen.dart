import 'package:flutter/material.dart';
import '../medical_staff/medical_staff_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الرئيسية')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildFeatureCard(
              context,
              'حضانات',
              Icons.child_care,
              Colors.orange,
            ),
            _buildFeatureCard(
              context,
              'عناية مركزة',
              Icons.local_hospital,
              Colors.red,
            ),
            _buildFeatureCard(context, 'طاقم طبي', Icons.people, Colors.green),
            _buildFeatureCard(
              context,
              'طلبات الحجز',
              Icons.book_online,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Card(
      color: color.withOpacity(0.1),
      child: InkWell(
        onTap: () {
          if (title == 'طاقم طبي') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MedicalStaffScreen(),
              ),
            );
          } else {
            // Other logic or just placeholder
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('الانتقال إلى $title')));
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
