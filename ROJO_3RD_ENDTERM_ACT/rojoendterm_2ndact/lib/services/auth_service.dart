import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirestoreService _firestore = FirestoreService();
  Future<void>? _googleInit;

  Stream<User?> authState() => _auth.authStateChanges();

  Future<UserCredential> registerWithEmail(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> loginWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signInWithGoogle() async {
    final provider = GoogleAuthProvider()
      ..setCustomParameters({'prompt': 'select_account'});
    if (kIsWeb) {
      final credential = await _auth.signInWithPopup(provider);
      await _firestore.saveUserProfile(
        role: 'User',
        availabilityDate: null,
        availabilityTime: null,
      );
      return credential;
    }
    await _ensureGoogleInitialized();
    late GoogleSignInAccount googleUser;
    try {
      googleUser = await _googleSignIn.authenticate(
        scopeHint: const <String>['email'],
      );
    } on GoogleSignInException catch (e) {
      throw FirebaseAuthException(code: e.code.name, message: e.message);
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final result = await _auth.signInWithCredential(credential);
    await _firestore.saveUserProfile(
      role: 'User',
      availabilityDate: null,
      availabilityTime: null,
    );
    return result;
  }

  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> saveRoleAndAvailability({
    required String role,
    required DateTime? date,
    required String? time,
  }) {
    return _firestore.saveUserProfile(
      role: role,
      availabilityDate: date,
      availabilityTime: time,
    );
  }

  Future<void> logout() async {
    await _ensureGoogleInitialized();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> _ensureGoogleInitialized() {
    return _googleInit ??= _googleSignIn.initialize();
  }
}
