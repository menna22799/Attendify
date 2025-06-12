import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'face_verification_screen.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  Future<void> login() async {
    final dbHelper = DatabaseHelper();
    final user = await dbHelper.getUserByEmail(emailController.text);

    if (user != null && user['password'] == passwordController.text) {
      String storedFaceData = user['faceData'] ?? "";

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FaceVerificationScreen(
            storedFaceData: storedFaceData,
            userEmail: emailController.text,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String iconPath) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(iconPath, height: 20, width: 20),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: "Password",
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset('assets/icons/padlock.png', height: 20, width: 20),
        ),
        suffixIcon: IconButton(
          icon: Image.asset(
            _obscurePassword
                ? 'assets/icons/eye_off.png'
                : 'assets/icons/eye.png',
            height: 22,
            width: 22,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A2240),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(text,
            style: const TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/logo.png", height: 300),
              const SizedBox(height: 20),
              _buildTextField(
                  emailController, "E-mail", "assets/icons/email.png"),
              const SizedBox(height: 10),
              _buildPasswordField(),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                  child: const Text("Forgot Password?",
                      style: TextStyle(color: Colors.black54)),
                ),
              ),
              const SizedBox(height: 10),
              _buildButton("Log In", login),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: const Text(
                      " Sign up",
                      style: TextStyle(
                          color: Color(0xFF0A2240),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
