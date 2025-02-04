// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyAS0v0ruPZTR2s_r8VnHWN3rV3voIE3kgM',
    appId: '1:286363774261:web:d1e213974e96296bec707c',
    messagingSenderId: '286363774261',
    projectId: 'chat-app-e801b',
    authDomain: 'chat-app-e801b.firebaseapp.com',
    storageBucket: 'chat-app-e801b.appspot.com',
    measurementId: 'G-EJS261TLL1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAjOENrieDJiDrK-91VJ3_oIv_N-UKLieg',
    appId: '1:286363774261:android:1ebcb6e9461ef03dec707c',
    messagingSenderId: '286363774261',
    projectId: 'chat-app-e801b',
    storageBucket: 'chat-app-e801b.appspot.com',
  );
}
