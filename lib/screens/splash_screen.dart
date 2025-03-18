import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart'; // Ensure the correct path to your LoginScreen

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Navigate to the next screen after a delay
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(), // Navigate to LoginScreen
        ),
      );
    });

    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Use theme color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo-filled.png',
              height: 100,
            ), // Add your logo here
            SizedBox(height: 20),
            CircularProgressIndicator(), // Optional: loading indicator
            SizedBox(height: 20),
            Text(
              "Welcome to Admin",
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
