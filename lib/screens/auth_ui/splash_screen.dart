import 'dart:async';
import 'package:e_comm/screens/auth_ui/welcome_screen.dart';
import 'package:e_comm/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:e_comm/screens/user_panel/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() {
    print('///////////////////////Edited');
    Timer(const Duration(seconds: 3), () {
      Get.offAll(() => WelcomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appSplash,
      appBar: AppBar(backgroundColor: AppConstant.appSplash, elevation: 0),
      body: Column(
        children: [
          Expanded(
            child: Center(
              // ✅ Proper alignment
              child: Lottie.asset(
                'assets/images/splash_animation.json',
                width: 300,
                height: 300,
                fit: BoxFit.contain, // ✅ Ensures proper scaling
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Text(
              AppConstant.appPoweredBy,
              style: TextStyle(
                color: AppConstant.appTextColor,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
