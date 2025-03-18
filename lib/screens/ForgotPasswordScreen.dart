import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import for responsive design

Color maroonColor = const Color(0xff800000); // Your custom maroon color

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // This function simulates the sending of the reset password link
  Future<void> _sendResetLink(String email) async {
    // Simulate a delay for sending an email
    await Future.delayed(const Duration(seconds: 2));

    // Simulate a success response
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Link Sent'),
          content: Text('A reset link has been sent to $email.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Navigate back to login screen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maroonColor, // Your custom maroon color
        title: Text('Forgot Password',
            style: TextStyle(fontSize: 20.sp)), // Responsive title size
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w), // Responsive padding
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reset your password",
                style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold), // Responsive font size
              ),
              SizedBox(height: 10.h), // Responsive height
              Text(
                "Please enter your email address. You will receive a link to create a new password via email.",
                style: TextStyle(fontSize: 16.sp), // Responsive font size
              ),
              SizedBox(height: 30.h), // Responsive height
              _textInput(
                controller: _emailController,
                hint: "Enter your Email",
                icon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Basic email validation
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h), // Responsive height
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String email = _emailController.text;
                      _sendResetLink(email); // Call function to send reset link
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maroonColor, // Your custom maroon color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Responsive border radius
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 30.w, vertical: 15.h), // Responsive padding
                    child: Text(
                      "Send Reset Link",
                      style: TextStyle(fontSize: 18.sp), // Responsive text size
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator, // Added validator function
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator, // Apply validation
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: maroonColor), // Use maroon icon color
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              horizontal: 15.w, vertical: 15.h), // Responsive content padding
        ),
      ),
    );
  }
}
