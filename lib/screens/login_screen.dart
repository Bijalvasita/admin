import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'SignUp.dart';
import 'dashboard_screen.dart';

Color maroonColor = const Color(0xff800000); // Maroon color
Color goldColor = const Color(0xffFFD700); // Gold color

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // To toggle password visibility

  Future<void> checkCredentials() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (credential.user != null) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
            (route) => false,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String tempErrorMsg = e.code;
      print(tempErrorMsg);
      switch (tempErrorMsg) {
        case "invalid-email":
        case "invalid-credential":
          showErrorDialog("Please Enter Valid Email Or Password.");
          break;
        default:
          showErrorDialog("Something Went Wrong.");
          break;
      }
    }
  }

  // Show DialogBox.
  void showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              const Icon(Icons.error, color: Colors.red),
              Text(errorMessage, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 10),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      },
    );
  }

  // Function for reset password link sent to registered email ID
  void sentLink() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      showErrorDialog("Password reset link has been sent to your email.");
    } catch (e) {
      showErrorDialog("Error sending reset link.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 30.h),
        child: Column(
          children: <Widget>[
            const HeaderContainer(),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    _textInput(
                      controller: _emailController,
                      hint: "Enter your Email",
                      icon: Icons.email,
                    ),
                    _textInput(
                      controller: _passwordController,
                      hint: "Password",
                      icon: Icons.vpn_key,
                      obscureText: true, // This will enable the eye icon
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.h),
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                child: StatefulBuilder(
                                  builder: (context, setState) {
                                    return SizedBox(
                                      height: 150,
                                      width: 400,
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            margin: const EdgeInsets.only(
                                                top: 13.0, right: 8.0),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 25),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 30,
                                                    child: TextField(
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                                  "Enter Valid Email"),
                                                      controller:
                                                          _emailController,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 30),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Link will be sent to mail to reset password",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .blueGrey),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      MaterialButton(
                                                        color: Colors.yellow,
                                                        onPressed: () {
                                                          sentLink(); // Call reset link method
                                                        },
                                                        child: const Text(
                                                            "Submit"),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0.0,
                                            child: InkWell(
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromRGBO(
                                                              204,
                                                              204,
                                                              204,
                                                              1)),
                                                  color: Colors.blue,
                                                ),
                                                child: const Icon(
                                                    Icons.close_sharp,
                                                    color: Colors.white),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        checkCredentials(); // Call to check user credentials
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: maroonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Text("LOGIN", style: TextStyle(fontSize: 16.sp)),
                    ),
                    SizedBox(height: 20.h),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                            text: "Signup",
                            style: TextStyle(color: maroonColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUp(),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _textInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 10.w),
      child: TextFormField(
        controller: controller,
        obscureText:
            obscureText ? !_isPasswordVisible : false, // Toggle visibility
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(icon),
          suffixIcon: obscureText
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible =
                          !_isPasswordVisible; // Toggle visibility state
                    });
                  },
                )
              : null, // Only show eye icon for password field
        ),
      ),
    );
  }
}

class HeaderContainer extends StatelessWidget {
  const HeaderContainer({super.key});

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
            bottom: 20.h,
            right: 20.w,
            child: Text(
              "Login",
              style: TextStyle(color: Colors.white, fontSize: 20.sp),
            ),
          ),
          Center(
            child: Image.asset(
              "assets/logo-filled.png",
              height: 100.h,
              width: 100.w,
            ),
          ),
        ],
      ),
    );
  }
}
