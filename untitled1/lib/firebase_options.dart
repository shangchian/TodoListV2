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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9HI24WCmiNivP_-CLZuQ_sg9RvBBmi3s',
    appId: '1:742401111655:android:6305a0f523134208dd86c2',
    messagingSenderId: '742401111655',
    projectId: 'todolist-b1783',
    databaseURL: 'https://todolist-b1783-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'todolist-b1783.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA-KdZZtoVS67OiQtbxb0ukyjgHjsg3KkE',
    appId: '1:742401111655:ios:2ed274116e8f7854dd86c2',
    messagingSenderId: '742401111655',
    projectId: 'todolist-b1783',
    databaseURL: 'https://todolist-b1783-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'todolist-b1783.appspot.com',
    iosBundleId: 'com.example.untitled1',
  );
}
