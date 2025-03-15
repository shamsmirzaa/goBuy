import 'dart:async';
import 'package:e_comm/controllers/get_user_data_controller.dart';
import 'package:e_comm/screens/admin_panel/admin_panel_screen.dart';
import 'package:e_comm/screens/auth_ui/welcome_screen.dart';
import 'package:e_comm/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() {
    print('///////////////////////Edited');
    Timer(const Duration(seconds: 3), () {
      loggdin(context);
    });
  }

  Future<void> loggdin(BuildContext context) async {
    if (user != null) {
      final GetUserDataController getUserDataController = Get.put(
        GetUserDataController(),
      );
      var userData = await getUserDataController.getUserData(user!.uid);

      if (userData[0]['isAdmin'] == true) {
        Get.offAll(() => AdminMainScreen());
      } else {
        Get.offAll(() => MainScreen());
      }
    } else {
      Get.to(() => WelcomeScreen());
    }
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
