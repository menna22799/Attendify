import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'login_screen.dart';
import 'QRScannerPage.dart';

class ProfileScreen extends StatefulWidget {
  final String userEmail;

  const ProfileScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "Loading...";
  String nationalId = "Loading...";
  String email = "Loading...";
  String id = "Loading...";
  String band = "Loading...";

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserDataFromDB();
  }

  Future<void> _loadUserDataFromDB() async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [widget.userEmail],
    );

    if (result.isNotEmpty) {
      final Map<String, dynamic> user = result.first;

      setState(() {
        name = user['name'] ?? 'Unknown';
        email = user['email'] ?? 'Unknown';
        id = user['userId']?.toString() ?? 'Unknown';
        band = user['band'] ?? 'Unknown';
        nationalId = user['nationalId'] ?? 'Unknown';
      });
    } else {
      setState(() {
        name = 'No User Found';
        email = '';
        id = '';
        band = '';
        nationalId = '';
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QRCodePage(userEmail: widget.userEmail),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildHeader(),
            const SizedBox(height: 10),
            _buildTitleSection(),
            const SizedBox(height: 50),
            _buildMainContent(),
          ],
        ),
      ),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/10.png', height: 100),
          Image.asset('assets/cloudic_logo.png', height: 100),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: const [
        Text(
          'بوابة الطالب',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 3),
        Text(
          'جامعة القاهرة الجديدة التكنولوجية',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        _buildInfoContainer(),
        Positioned(
          top: -40,
          child: CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey.shade300,
              child: Image.asset(
                'assets/icons/account.png',
                height: 50,
                width: 50,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoContainer() {
    return Container(
      width: double.infinity,
      height: 900,
      decoration: const BoxDecoration(
        color: Color(0xFF6A9FB5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60),
          topRight: Radius.circular(60),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
      child: Column(
        children: [
          buildInfoTile('الاسم', name),
          buildInfoTile('الكود', id),
          buildInfoTile('الفرقة', band),
          buildInfoTile('الرقم القومي', nationalId),
          buildInfoTile('البريد الإلكتروني', email),
        ],
      ),
    );
  }

  Widget buildInfoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Container(
            height: 70,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF3E6B80),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
