import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform != TargetPlatform.android) {
      throw UnsupportedError('This app is only configured for Android.');
    }

    return FirebaseOptions(
      apiKey: dotenv.env['API_KEY_ANDROID']!,
      appId: '1:869481983448:android:fec34de1615166a49e16ad',
      messagingSenderId: '869481983448',
      projectId: 'gobuy-ecom',
      storageBucket: 'gobuy-ecom.firebasestorage.app',
    );
  }
}
