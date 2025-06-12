import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'database_helper.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  String? selectedBand;
  File? _capturedImage;

  Future<void> _captureFace() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    final inputImage = InputImage.fromFilePath(pickedFile.path);
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
        enableContours: false,
        enableLandmarks: false,
      ),
    );

    final List<Face> faces = await faceDetector.processImage(inputImage);
    await faceDetector.close();

    if (faces.isNotEmpty) {
      setState(() {
        _capturedImage = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No face detected. Please try again.")),
      );
    }
  }

  Future<void> _saveUserData() async {
    if (_capturedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please capture a clear face image.")),
      );
      return;
    }

    final user = {
      'name': nameController.text,
      'nationalId': nationalIdController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'band': selectedBand ?? "Not Selected",
      'userId': idController.text,
      'profileImage': _capturedImage!.path,
      'faceData': "captured", // optional metadata
    };

    final dbHelper = DatabaseHelper();
    await dbHelper.insertUser(user);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String label, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Image.asset("assets/signup_image.png", height: 150),
            const SizedBox(height: 20),
            _buildTextField("Name", "Enter Your Name", nameController),
            _buildTextField(
                "National ID", "Enter Your National ID", nationalIdController),
            _buildTextField("Email", "Enter Your Email", emailController),
            _buildTextField(
                "Password", "Enter Your Password", passwordController,
                isPassword: true),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField("Band", ["1", "2", "3", "4"],
                      (value) {
                    setState(() {
                      selectedBand = value;
                    });
                  }),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child:
                        _buildTextField("ID", "Enter Your ID", idController)),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _captureFace,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _capturedImage == null
                    ? const Icon(Icons.camera_alt, size: 40)
                    : Image.file(_capturedImage!,
                        width: 100, height: 100, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A2240),
                minimumSize: const Size(180, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _saveUserData,
              child: const Text(
                'Sign Up',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
