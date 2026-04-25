import 'package:flutter/material.dart';
import 'package:my_app/hospital_booking.dart'; 
void main() {
  runApp(const ShifaaApp());
}
class ShifaaApp extends StatelessWidget {
  const ShifaaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shifaa',
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        primaryColor: const Color(0xFF0D47A1), 
        scaffoldBackgroundColor: Colors.white,
      ),

      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const HospitalBookingsScreen(), 
    );
  }
}