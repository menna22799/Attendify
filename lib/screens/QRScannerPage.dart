import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'database_helper.dart';

class QRCodePage extends StatefulWidget {
  final String userEmail; // الإيميل الذي تم تسجيل الدخول به

  const QRCodePage({Key? key, required this.userEmail}) : super(key: key);

  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  String userProfileData = ''; // بيانات المستخدم للـ QR
  bool _isQRCodeVisible = false;
  String qrText = '';
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userEmail: widget.userEmail),
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
  void initState() {
    super.initState();
    loadUserDataFromDB(); // تحميل بيانات المستخدم
  }

  Future<void> loadUserDataFromDB() async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [widget.userEmail],
    );

    if (result.isNotEmpty) {
      final Map<String, dynamic> user = result.first;

      String name = user['name'] ?? 'Unknown';
      String studentId = user['userId']?.toString() ?? 'Unknown';
      String band = user['band'] ?? 'Unknown';

      setState(() {
        userProfileData = 'Name: $name\nID: $studentId\nBand: $band';
      });
    } else {
      setState(() {
        userProfileData = 'No user data found';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "QR Code",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0C1D35),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            qrText,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF6A9FB5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _isQRCodeVisible
                        ? Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6A9FB5),
                              border: Border.all(color: Colors.black, width: 3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: QrImageView(
                              data: userProfileData,
                              version: QrVersions.auto,
                              size: 200,
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3E6B80),
                        minimumSize: const Size(180, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isQRCodeVisible = true;
                          qrText = 'QR Code Generated';
                        });

                        Future.delayed(const Duration(seconds: 10), () {
                          setState(() {
                            _isQRCodeVisible = false;
                            qrText = '';
                          });
                        });
                      },
                      child: const Text(
                        'Generate',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
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
}
