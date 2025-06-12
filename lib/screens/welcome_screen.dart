import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart'; // استيراد صفحة تسجيل الدخول

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();

    // تأخير لمدة 10 ثوانٍ قبل التوجيه إلى صفحة تسجيل الدخول
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // الانتقال إلى LoginScreen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // القسم العلوي مع الشعار
          Stack(
            children: [
              Container(
                height: 180,
                decoration: const BoxDecoration(
                  color: Color(0xFF0A2240), // لون الخلفية الكحلي
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(400),
                    bottomRight: Radius.circular(400),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/cloudic_logo.png', // استبدل بشعار Cloudic
                      height: 100,
                    ),
                    const SizedBox(height: 5),

                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // نص الترحيب
          const Text(
            "WELCOME",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'PressStart2P', // استخدام خط مميز إذا توفر
            ),
          ),

          const SizedBox(height: 50),

          // صورة العناصر التقنية أسفل الصفحة
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/tech_background.png', // استبدل بالصورة الفعلية لديك
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
