// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
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
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCVHPFGALs0-JMCy-Rh4s2vy89qh6deu94',
    appId: '1:713037138768:web:577c3be8a088895e4d7a55',
    messagingSenderId: '713037138768',
    projectId: 'bai3-e4cd0',
    authDomain: 'bai3-e4cd0.firebaseapp.com',
    storageBucket: 'bai3-e4cd0.appspot.com',
    measurementId: 'G-79R13V36HS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAtSx_DC34s1M49wyzU7LXVVGNB_Rl28OE',
    appId: '1:713037138768:android:66d65898548cdfdc4d7a55',
    messagingSenderId: '713037138768',
    projectId: 'bai3-e4cd0',
    storageBucket: 'bai3-e4cd0.appspot.com',
  );
}