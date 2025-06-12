import 'package:flutter/material.dart';
import 'dart:async';
import 'welcome_screen.dart'; // استيراد صفحة الترحيب

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // تأخير الانتقال لمدة 10 ثوانٍ
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()), // الانتقال إلى صفحة الترحيب
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/splash_logo.png', // استبدلها بشعار البداية الخاص بك
          width: 200,
        ),
      ),
    );
  }
}
