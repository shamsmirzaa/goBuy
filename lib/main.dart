import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:e_comm/screens/auth_ui/splash_screen.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'screens/auth_ui/sign_in_screen.dart';
import 'screens/auth_ui/sign_up.dart';

import 'screens/user_panel/main_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SignUpScreen(),
    );
  }
}
