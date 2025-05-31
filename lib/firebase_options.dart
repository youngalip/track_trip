import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyADseQDlrLY5m3k1H2LJfQbbJC1VeRFt2g',
    authDomain: 'track-trip-firebase.firebaseapp.com',
    projectId: 'track-trip-firebase',
    storageBucket: 'track-trip-firebase.firebasestorage.app',
    messagingSenderId: '830186307120',
    appId: '1:830186307120:web:27e3396b05a464075fb7f5',
    measurementId: 'G-JGNVP0MMT6',
  );

  // Tambahkan konfigurasi platform lain jika perlu
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '...',
    appId: '...',
    messagingSenderId: '...',
    projectId: 'track-trip-firebase',
    storageBucket: 'track-trip-firebase.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '...',
    appId: '...',
    messagingSenderId: '...',
    projectId: 'track-trip-firebase',
    storageBucket: 'track-trip-firebase.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: '...',
    appId: '...',
    messagingSenderId: '...',
    projectId: 'track-trip-firebase',
    storageBucket: 'track-trip-firebase.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: '...',
    appId: '...',
    messagingSenderId: '...',
    projectId: 'track-trip-firebase',
    storageBucket: 'track-trip-firebase.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: '...',
    appId: '...',
    messagingSenderId: '...',
    projectId: 'track-trip-firebase',
    storageBucket: 'track-trip-firebase.firebasestorage.app',
  );
}
