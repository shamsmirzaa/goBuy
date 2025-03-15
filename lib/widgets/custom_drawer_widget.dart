import 'package:e_comm/screens/auth_ui/welcome_screen.dart';
import 'package:e_comm/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Get.height / 25),
      child: SizedBox(
        width: 250, // Set to a fixed width in pixels
        child: Drawer(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Wrap(
            runSpacing: 10,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text(
                    "goBuy",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  subtitle: Text(
                    "Version 1.0.1",
                    style: TextStyle(color: Colors.black87),
                  ),
                  leading: CircleAvatar(
                    radius: 22.0,
                    backgroundColor: AppConstant.appMainColor,
                    child: Text(
                      "G",
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                    ),
                  ),
                ),
              ),
              Divider(
                indent: 10.0,
                endIndent: 10.0,
                thickness: 1.5,
                color: Colors.white60,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text("Home", style: TextStyle(color: Colors.black87)),
                  leading: Icon(Icons.home, color: Colors.black87),
                  trailing: Icon(Icons.arrow_forward, color: Colors.black87),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text(
                    "Products",
                    style: TextStyle(color: Colors.black87),
                  ),
                  leading: Icon(Icons.shopping_cart, color: Colors.black87),
                  trailing: Icon(Icons.arrow_forward, color: Colors.black87),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text(
                    "Orders",
                    style: TextStyle(color: Colors.black87),
                  ),
                  leading: Icon(Icons.shopping_bag, color: Colors.black87),
                  trailing: Icon(Icons.arrow_forward, color: Colors.black87),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text(
                    "Contact",
                    style: TextStyle(color: Colors.black87),
                  ),
                  leading: Icon(Icons.help, color: Colors.black87),
                  trailing: Icon(Icons.arrow_forward, color: Colors.black87),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListTile(
                  onTap: () async {
                    GoogleSignIn googleSignIn = GoogleSignIn();
                    FirebaseAuth _auth = FirebaseAuth.instance;
                    await _auth.signOut();

                    await googleSignIn.signOut();
                    Get.offAll(() => WelcomeScreen());
                  },
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text(
                    "Logout",
                    style: TextStyle(color: Colors.black87),
                  ),
                  leading: Icon(Icons.logout, color: Colors.black87),
                  trailing: Icon(Icons.arrow_forward, color: Colors.black87),
                ),
              ),
            ],
          ),
          backgroundColor: AppConstant.appSecondaryColor,
        ),
      ),
    );
  }
}
