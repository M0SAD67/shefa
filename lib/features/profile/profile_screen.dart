import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = 'ProfileScreen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // تعريف المتحكمات للبيانات (Controllers)
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
    text: "123456789",
  );

  // دالة لإظهار نافذة التعديل (Bottom Sheet)
  void _showEditBottomSheet(
    String title,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    bool obscureText = isPassword; // متغير محلي للتحكم في الرؤية داخل الـ Modal

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // عشان الكيبورد
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "تعديل $title",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF083345),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  obscureText: obscureText,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    // أيقونة العين تظهر فقط في حالة كلمة السر
                    prefixIcon: isPassword
                        ? IconButton(
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xFF2D7FA3),
                            ),
                            onPressed: () {
                              setModalState(() {
                                obscureText = !obscureText;
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF80B541)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF80B541),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      setState(
                        () {},
                      ); // تحديث الصفحة الأساسية بالبيانات الجديدة
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "حفظ التعديلات",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/logo/logo.png'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFCDE2E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Color(0xFF083345)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // الخلفية
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/background/background-reduce-opacity.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // الصورة الشخصية
                const Center(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Color(0xFF083345),
                    backgroundImage: AssetImage(
                      'assets/images/user_avatar.png',
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // تعديل الاسم
                _buildEditableText(
                  _nameController.text,
                  onEdit: () => _showEditBottomSheet("الاسم", _nameController),
                  fontSize: 24,
                  isBold: true,
                ),
                // تعديل العنوان
                _buildEditableText(
                  _addressController.text,
                  onEdit: () =>
                      _showEditBottomSheet("العنوان", _addressController),
                  fontSize: 16,
                  color: Colors.grey,
                ),

                const SizedBox(height: 30),
                const Divider(
                  color: Color(0xFF2D7FA3),
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 20),

                // كروت البيانات
                _buildProfileCard(
                  "رقم التليفون :",
                  _phoneController.text,
                  onTap: () =>
                      _showEditBottomSheet("رقم التليفون", _phoneController),
                ),
                _buildProfileCard(
                  "البريد الإلكتروني :",
                  _emailController.text,
                  onTap: () => _showEditBottomSheet(
                    "البريد الإلكتروني",
                    _emailController,
                  ),
                ),
                _buildProfileCard(
                  "الرقم السري",
                  "************",
                  onTap: () => _showEditBottomSheet(
                    "الرقم السري",
                    _passwordController,
                    isPassword: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت النصوص العلوية (الاسم والعنوان)
  Widget _buildEditableText(
    String text, {
    required VoidCallback onEdit,
    double fontSize = 14,
    Color color = const Color(0xFF083345),
    bool isBold = false,
  }) {
    return GestureDetector(
      onTap: onEdit,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.edit_outlined, size: 18, color: color.withOpacity(0.6)),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: color,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت كروت البيانات الشخصية
  Widget _buildProfileCard(
    String title,
    String value, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFCDE2E9), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.edit_outlined, color: Color(0xFF2D7FA3)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF083345),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF2D7FA3),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
