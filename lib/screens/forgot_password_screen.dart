import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {

  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final codeController = TextEditingController();
    final newPasswordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/4.png",
                height: 250,
              ),
              const SizedBox(height: 40),

              // Email + Get Code
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "E-mail",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // هنا تبعت الكود على الإيميل
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0A2240),
                    ),
                    child: const Text("Get Code", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Verification Code
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: "Verification Code",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // New Password
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "New Password",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // تحقق من الكود وغير الباسورد
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0A2240),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    "Reset",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
