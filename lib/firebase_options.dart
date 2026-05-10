import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
        // this is for Web launch
        show
        defaultTargetPlatform,
        kIsWeb,
        TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCgRxrbcaoDX3jRCNyYhMY3IOHXvfWjs98',
    authDomain: 'task-manager-app-flutter-4daa0.firebaseapp.com',
    projectId: 'task-manager-app-flutter-4daa0',
    storageBucket: 'task-manager-app-flutter-4daa0.firebasestorage.app',
    messagingSenderId: '448857182774',
    appId: '1:448857182774:web:9105cbcef2f49827b17e97',
    measurementId: 'G-SL8ZHH2K7T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCgRxrbcaoDX3jRCNyYhMY3IOHXvfWjs98',
    appId: '1:448857182774:android:c5e439cd71c4b5cfb17e97',
    messagingSenderId: '448857182774',
    projectId: 'task-manager-app-flutter-4daa0',
    storageBucket: 'task-manager-app-flutter-4daa0.firebasestorage.app',
  );
}
