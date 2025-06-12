import 'package:flutter/material.dart';
import 'screens/profile_screen.dart';
import 'screens/QRScannerPage.dart';
import 'screens/login_screen.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendfiy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(), // أو SplashScreen() لو بتستخدم شاشة تحميل أولاً
    );
  }
}

class MainScreen extends StatefulWidget {
  final String userEmail;

  const MainScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      ProfileScreen(userEmail: widget.userEmail),
      QRCodePage(userEmail: widget.userEmail),
      const Scaffold(body: Center(child: Text("Logging Out...")))
    ];

    void _onItemTapped(int index) {
      if (index == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        setState(() {
          _selectedIndex = index;
        });
      }
    }

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "QR"),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Log out"),
        ],
      ),
    );
  }
}
