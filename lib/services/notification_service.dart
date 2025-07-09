// ignore_for_file: avoid_print, unused_local_variable

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationService {
  // Initializing Firebase Messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Send notification request
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      // FIX: Use "else if" instead of "elseif"
      print('User granted provisional permission');
    } else {
      Get.snackbar(
        "Notification Permission Denied",
        "Please enable notifications in settings.",
        snackPosition: SnackPosition.BOTTOM,
      );
      Future.delayed(Duration(seconds: 2), () {
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      });
    }
  }

  //get token
  Future<String> getDeviceToken() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    String? token = await messaging.getToken();
    print("token=>$token");
    return token!;
  }
}
