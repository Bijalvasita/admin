import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dashboard_screen.dart';
import 'login_screen.dart';

// Updated colors to Maroon and Gold
Color maroonColor = const Color(0xff800000); // Maroon
Color goldColor = const Color(0xffFFD700); // Gold

class SignUp extends StatefulWidget {
  static const String path = "lib/src/pages/login/signup.dart";

  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Validation check for email
  bool _isEmailValid(String email) {
    return email.contains('@');
  }

  // Validation check for phone number
  bool _isPhoneNumberValid(String phone) {
    return phone.length == 10 && RegExp(r'^[0-9]+$').hasMatch(phone);
  }

  // Validation check for password
  bool _isPasswordValid(String password) {
    return password.length >= 6 &&
        RegExp(r'^(?=.*?[!@#$%^&*()_+])[A-Za-z0-9!@#$%^&*()_+]+$')
            .hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 30.h), // Responsive padding
        child: Column(
          children: <Widget>[
            const HeaderContainer("Signup For"),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 20.w, vertical: 30.h), // Responsive margins
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _textInput(
                    controller: _fullNameController,
                    hint: "Fullname",
                    icon: Icons.person,
                  ),
                  _textInput(
                    controller: _emailController,
                    hint: "Email",
                    icon: Icons.email,
                  ),
                  _textInput(
                    controller: _dobController,
                    hint: "Date of Birth (DD/MM/YYYY)",
                    icon: Icons.calendar_today,
                  ),
                  _textInput(
                    controller: _phoneController,
                    hint: "Phone Number (10 digits)",
                    icon: Icons.call,
                    keyboardType: TextInputType.phone,
                  ),
                  _textInput(
                    controller: _passwordController,
                    hint: "Password (min 6 chars, with special case)",
                    icon: Icons.vpn_key,
                    obscureText: true, // Hide password input
                  ),
                  Center(
                    child: ButtonWidget(
                      btnText: "SIGNUP",
                      onClick: () {
                        // Validate inputs before navigating
                        if (_fullNameController.text.isEmpty) {
                          _showErrorDialog("Full name cannot be empty");
                          return;
                        }
                        if (!_isEmailValid(_emailController.text)) {
                          _showErrorDialog("Please enter a valid email");
                          return;
                        }
                        if (!_isPhoneNumberValid(_phoneController.text)) {
                          _showErrorDialog("Phone number must be 10 digits");
                          return;
                        }
                        if (!_isPasswordValid(_passwordController.text)) {
                          _showErrorDialog(
                              "Password must be at least 6 characters long and include a special character");
                          return;
                        }
                        // Navigate to Dashboard with user data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Already a member? ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: "SIGNIN",
                          style: TextStyle(color: maroonColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _textInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 10.h), // Responsive margin
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 10.w), // Responsive padding
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}

class HeaderContainer extends StatelessWidget {
  final String text;

  const HeaderContainer(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [maroonColor, goldColor],
          end: Alignment.bottomCenter,
          begin: Alignment.topCenter,
        ),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(100)),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 20.h, // Responsive position
            right: 20.w, // Responsive position
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white, fontSize: 20.sp), // Responsive text size
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final String btnText;
  final Function onClick;

  const ButtonWidget({super.key, required this.btnText, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(),
      child: Container(
        width: double.infinity,
        height: 40.h, // Responsive height
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [maroonColor, goldColor],
            end: Alignment.centerLeft,
            begin: Alignment.centerRight,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
        alignment: Alignment.center,
        child: Text(
          btnText,
          style: TextStyle(
            fontSize: 20.sp, // Responsive font size
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
