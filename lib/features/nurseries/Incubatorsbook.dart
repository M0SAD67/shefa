import 'package:flutter/material.dart';
import 'package:my_app/constants/assets_app.dart';
import 'package:my_app/theme/color_app.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedBookingType = 1;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Scaffold(
        backgroundColor: ColorApp.appLight,
        body: Column(
          children: [
          
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 15,
                bottom: 15,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: ColorApp.appLight,
                border: Border(
                  bottom: BorderSide(
                    color: ColorApp.locationText.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorApp.appAmoled.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: ColorApp.primary.withOpacity(0.2),
                    backgroundImage: const AssetImage(AssetsApp.userAvatar),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'علي عماد',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: ColorApp.appDark,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text('👋', style: TextStyle(fontSize: 17)),
                          ],
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'الفلل بنها القليوبيه',
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorApp.locationText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(AssetsApp.logo, height: 50),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: ColorApp.buttonDetails,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: ColorApp.primary,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorApp.secondary, width: 1.5),
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        AssetsApp.icOnboard1, 
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  const Text(
                    'حضانات أطفال',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: ColorApp.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: 0.15,
                        child: Image.asset(
                          AssetsApp.bgOnboardOpacity,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Column(
                      children: [
                        _buildBookingFormCard(),
                        
                        const SizedBox(height: 30),
                        
                        _buildConfirmButton(),
                        
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingFormCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: ColorApp.buttonDetails,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorApp.appAmoled.withOpacity(0.04),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'مستشفي بنها الجامعي',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorApp.icons,
            ),
          ),
          const SizedBox(height: 24),

          _buildRadioOption(
            title: 'حضانات أطفال',
            emoji: '🍼',
            value: 1,
          ),
          const SizedBox(height: 10),
          _buildRadioOption(
            title: 'العناية لحديثي الولادة (NICU)',
            emoji: '👶',
            value: 2,
          ),
          const SizedBox(height: 24),

          _buildTextField(hintText: 'اسم الطفل'),
          _buildTextField(hintText: 'رقم تليفون', isPhone: true),
          _buildTextField(hintText: 'الحالة الطبية'),
        ],
      ),
    );
  }


  Widget _buildRadioOption({
    required String title,
    required String emoji,
    required int value,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedBookingType = value;
        });
      },
      child: Row(
        children: [
          Radio<int>(
            value: value,
            groupValue: _selectedBookingType,
            activeColor: ColorApp.secondary, 
            onChanged: (int? newValue) {
              setState(() {
                _selectedBookingType = newValue!;
              });
            },
          ),
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: ColorApp.icons,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String hintText, bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        textAlign: TextAlign.center, 
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: ColorApp.locationText.withOpacity(0.6),
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          filled: true,
          fillColor: Colors.white.withOpacity(0.5), 
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: ColorApp.secondary, width: 1), 
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: ColorApp.primary, width: 1.5), 
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return InkWell(
      onTap: () {
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 200, 
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: ColorApp.buttonDetails,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: ColorApp.secondary.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'تأكيد الحجز',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorApp.appAmoled,
            ),
          ),
        ),
      ),
    );
  }
}