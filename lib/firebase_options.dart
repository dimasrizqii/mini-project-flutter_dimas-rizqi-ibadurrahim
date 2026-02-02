import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyCRbMTYqbtP_H1CXOGTG7gWxMomDy88568',
    appId: '1:97311211374:web:9ee8fd509d9fc3eef3cb7f',
    messagingSenderId: '97311211374',
    projectId: 'tmdb-dimas',
    authDomain: 'tmdb-dimas.firebaseapp.com',
    storageBucket: 'tmdb-dimas.firebasestorage.app',
    measurementId: 'G-QLXFLZD6B3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA32JVSUrTsoKaZAJfYXU9A2kgm5SQ8LBE',
    appId: '1:97311211374:android:f5d9d4bd7435c328f3cb7f',
    messagingSenderId: '97311211374',
    projectId: 'tmdb-dimas',
    storageBucket: 'tmdb-dimas.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDcNomDNAyzpSzdsmDFXAVW_dfP3UhbnHI',
    appId: '1:97311211374:ios:3441eeb1a52a2e35f3cb7f',
    messagingSenderId: '97311211374',
    projectId: 'tmdb-dimas',
    storageBucket: 'tmdb-dimas.firebasestorage.app',
    iosBundleId: 'com.example.miniProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDcNomDNAyzpSzdsmDFXAVW_dfP3UhbnHI',
    appId: '1:97311211374:ios:3441eeb1a52a2e35f3cb7f',
    messagingSenderId: '97311211374',
    projectId: 'tmdb-dimas',
    storageBucket: 'tmdb-dimas.firebasestorage.app',
    iosBundleId: 'com.example.miniProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCRbMTYqbtP_H1CXOGTG7gWxMomDy88568',
    appId: '1:97311211374:web:86ce9a3e1d16b0f3f3cb7f',
    messagingSenderId: '97311211374',
    projectId: 'tmdb-dimas',
    authDomain: 'tmdb-dimas.firebaseapp.com',
    storageBucket: 'tmdb-dimas.firebasestorage.app',
    measurementId: 'G-BH6SGCB6R8',
  );
}
