import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini_project/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  static const String _userKey = 'logged_in_user';
  static const String _tokenKey = 'auth_token';

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token != null && currentUser != null;
  }

  // Save user data to local storage
  Future<void> _saveUserToLocal(UserModel user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setString(_tokenKey, token);
  }

  // Get user from local storage
  Future<UserModel?> getUserFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // Clear local storage
  Future<void> _clearLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  // Register with email and password
  Future<UserModel?> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Create user with email and password
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(displayName);

      // Get updated user
      await userCredential.user?.reload();
      final user = _auth.currentUser;

      if (user != null) {
        // Create user model
        final userModel = UserModel(
          uid: user.uid,
          email: user.email ?? email,
          displayName: displayName,
          photoUrl: user.photoURL,
        );

        // Save to Firestore
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());

        // Get token and save to local
        final token = await user.getIdToken();
        if (token != null) {
          await _saveUserToLocal(userModel, token);
        }

        return userModel;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Terjadi kesalahan: ${e.toString()}';
    }
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        // Get user data from Firestore
        final docSnapshot =
            await _firestore.collection('users').doc(user.uid).get();

        UserModel userModel;
        if (docSnapshot.exists) {
          userModel = UserModel.fromMap(docSnapshot.data()!);
        } else {
          // If no Firestore data, create from Firebase user
          userModel = UserModel.fromFirebaseUser(user);
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(userModel.toMap());
        }

        // Get token and save to local
        final token = await user.getIdToken();
        if (token != null) {
          await _saveUserToLocal(userModel, token);
        }

        return userModel;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Terjadi kesalahan: ${e.toString()}';
    }
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // User cancelled
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Create user model
        final userModel = UserModel.fromFirebaseUser(user);

        // Save to Firestore
        await _firestore.collection('users').doc(user.uid).set(
              userModel.toMap(),
              SetOptions(merge: true),
            );

        // Get token and save to local
        final token = await user.getIdToken();
        if (token != null) {
          await _saveUserToLocal(userModel, token);
        }

        return userModel;
      }
      return null;
    } catch (e) {
      throw 'Terjadi kesalahan saat login dengan Google: ${e.toString()}';
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await _clearLocalStorage();
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan login atau gunakan email lain.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-not-found':
        return 'Email tidak terdaftar. Silakan register terlebih dahulu.';
      case 'wrong-password':
        return 'Password salah. Silakan coba lagi.';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Silakan coba lagi nanti.';
      case 'operation-not-allowed':
        return 'Operasi tidak diizinkan.';
      default:
        return 'Terjadi kesalahan: ${e.message}';
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final user = currentUser;
      if (user != null) {
        if (displayName != null) {
          await user.updateDisplayName(displayName);
        }
        if (photoUrl != null) {
          await user.updatePhotoURL(photoUrl);
        }

        await user.reload();
        final updatedUser = _auth.currentUser;

        if (updatedUser != null) {
          final userModel = UserModel.fromFirebaseUser(updatedUser);
          await _firestore
              .collection('users')
              .doc(user.uid)
              .update(userModel.toMap());

          final token = await user.getIdToken();
          if (token != null) {
            await _saveUserToLocal(userModel, token);
          }
        }
      }
    } catch (e) {
      throw 'Gagal update profil: ${e.toString()}';
    }
  }
}
