import 'package:e_comm/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 300.0,
        backgroundColor: AppConstant.appSecondaryColor,
        flexibleSpace: Stack(
          children: [
            Center(
              // Center the Lottie animation
              child: Lottie.asset(
                'assets/images/splash_animation2.json',
                fit: BoxFit.contain,
                height: 250, // Adjust size as needed
              ),
            ),
            Positioned(
              // Position the text at the bottom
              bottom: 10, // Distance from bottom
              left: 0,
              right: 0,
              child: Text.rich(
                TextSpan(
                  text: "Welcome to ",
                  style: TextStyle(
                    color: Colors.white, // Adjust text color
                    fontSize: 25, // Adjust text size
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: "GoBuy",
                      style: TextStyle(
                        color: Colors.green, // Different color for "GoBuy"
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        // Ensures content is visible on all screens
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 30.0), // Add margin at the top
              child: Text(
                'Happy Shopping',
                style: TextStyle(
                  color: Colors.red,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            // Now it will push everything else below
            SizedBox(height: Get.height / 18),
            Material(
              child: SizedBox(
                width: 260,
                child: TextButton.icon(
                  icon: Image.asset(
                    'assets/images/google_icon.png',
                    height: 30,
                    width: 30,
                  ),
                  label: Text(
                    "Sign in with Google",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey[200],
                  ),
                ),
              ),
            ),
            SizedBox(height: Get.height / 40),
            Material(
              child: SizedBox(
                width: 260,
                child: TextButton.icon(
                  icon: Image.asset(
                    'assets/images/email_icon.png',
                    height: 30,
                    width: 30,
                  ),
                  label: Text(
                    "Sign in with E-mail",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {},
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
      ),
    );
  }
}
