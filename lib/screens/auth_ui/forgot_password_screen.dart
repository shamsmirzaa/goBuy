import 'package:e_comm/controllers/forgot_password_controller.dart';
import 'package:e_comm/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ForgotPasswordController forgotPasswordController = Get.put(
    ForgotPasswordController(),
  );
  TextEditingController userEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConstant.appSecondaryColor,
            centerTitle: true,
            title: Text(
              'Forgot Password',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Column(
            children: [
              // Show Lottie only when keyboard is NOT visible
              if (!isKeyboardVisible)
                Container(
                  alignment: Alignment.topCenter, // Center at top
                  padding: EdgeInsets.only(top: 10), // Add spacing from top
                  child: Lottie.asset(
                    'assets/images/profile_ima.json',
                    width: 200,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),

              SizedBox(height: 20), // Spacing
              // Email input field
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: userEmail,
                  cursorColor: AppConstant.appSecondaryColor,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),
              Material(
                child: SizedBox(
                  width: 260,
                  child: TextButton(
                    child: Text(
                      "Forgot",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      String email = userEmail.text.trim();

                      if (email.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Please enter all details",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppConstant.appSecondaryColor,
                          colorText: AppConstant.appTextColor,
                        );
                      } else {
                        String email = userEmail.text.trim();
                        forgotPasswordController.ForgotPasswordMethod(email);
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
