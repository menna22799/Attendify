import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:io';

import 'profile_screen.dart';

class FaceVerificationScreen extends StatefulWidget {
  final String storedFaceData;
  final String userEmail;

  const FaceVerificationScreen({
    Key? key,
    required this.storedFaceData,
    required this.userEmail,
  }) : super(key: key);

  @override
  _FaceVerificationScreenState createState() => _FaceVerificationScreenState();
}

class _FaceVerificationScreenState extends State<FaceVerificationScreen> {
  String? _imagePath;
  bool _isVerifying = false;

  Future<void> _captureFaceAndVerify() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    final inputImage = InputImage.fromFilePath(image.path);
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
        enableLandmarks: false,
        enableContours: false,
      ),
    );

    final faces = await faceDetector.processImage(inputImage);
    await faceDetector.close();

    if (faces.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No face detected. Try again.")),
      );
      return;
    }

    setState(() {
      _imagePath = image.path;
      _isVerifying = true;
    });

    // محاكاة عملية التحقق من الوجه
    await Future.delayed(const Duration(seconds: 2));

    bool faceMatch = _fakeFaceMatchCheck();

    setState(() {
      _isVerifying = false;
    });

    if (faceMatch) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userEmail: widget.userEmail),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Face verification failed.')),
      );
    }
  }

  bool _fakeFaceMatchCheck() {
    // تحقق وهمي: يعتبر الصورة مقبولة لو تم التقاطها وفيها وجه
    return _imagePath != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Face Verification')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imagePath == null
                ? const Text('Please capture your face')
                : Image.file(File(_imagePath!), width: 200, height: 200),
            const SizedBox(height: 20),
            _isVerifying
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _captureFaceAndVerify,
                    child: const Text('Capture & Verify Face'),
                  ),
          ],
        ),
      ),
    );
  }
}
