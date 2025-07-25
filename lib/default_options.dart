import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DefaultFirebaseOptions {
  static   FirebaseOptions? _android;
  static   FirebaseOptions? _ios;

  static void loadFirebaseApp(Map<String, dynamic> dotenv) {
    if (Platform.isAndroid) {
      _android = FirebaseOptions(
        apiKey: dotenv['ANDROID_API_KEY']!,
        appId: dotenv['ANDROID_APP_ID']!,
        messagingSenderId: dotenv['MESSAGING_SENDER_ID']!,
        projectId: dotenv['PROJECT_ID']!,
      );
    } else if (Platform.isIOS) {
      _ios = FirebaseOptions(
        apiKey: dotenv['IOS_API_KEY']!,
        appId: dotenv['IOS_APP_ID']!,
        messagingSenderId: dotenv['MESSAGING_SENDER_ID']!,
        projectId: dotenv['PROJECT_ID']!,
      );
    } else {
      throw Exception('Firebase environment variables are not set.');
    }
  }

  static FirebaseOptions get currentPlatform {

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _android!;
      case TargetPlatform.iOS:
        return _ios!;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }
}


