import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart'; // Untuk debugPrint

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Mendapatkan user yang sedang login (bisa null)
  User? get currentUser => _auth.currentUser;

  // Stream untuk memantau status login secara real-time
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // LOGIN GOOGLE
  Future<User?> signInWithGoogle() async {
    try {
      // 1. Memicu flow otentikasi (muncul pop-up pilih akun)
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User batal login

      // 2. Ambil token otentikasi dari request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Buat kredensial baru untuk Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Masuk ke Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
      
    } catch (e) {
      debugPrint("Error Login Google: $e");
      return null;
    }
  }

  // LOGOUT
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}