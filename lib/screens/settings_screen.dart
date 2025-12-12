import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = AuthService().currentUser;
    // Dengarkan perubahan auth secara real-time
    AuthService().authStateChanges.listen((user) {
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    });
  }

  void _handleAuthAction() async {
    if (_currentUser == null) {
      // JIKA BELUM LOGIN -> LOGIN
      await AuthService().signInWithGoogle();
    } else {
      // JIKA SUDAH LOGIN -> LOGOUT
      await AuthService().signOut();
      if (mounted) {
        // Kembali ke Home dan hapus history agar fresh
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = _currentUser != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Account"),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // 1. FOTO PROFIL
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
                image: isLoggedIn && _currentUser?.photoURL != null
                    ? DecorationImage(
                        image: NetworkImage(_currentUser!.photoURL!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: !isLoggedIn
                  ? const SizedBox() // Kosong jika belum login
                  : null,
            ),

            const SizedBox(height: 20),

            // 2. NAMA & EMAIL
            Text(
              isLoggedIn ? (_currentUser!.displayName ?? "User") : "-",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isLoggedIn ? (_currentUser!.email ?? "email@gmail.com") : "-",
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),

            const Spacer(),

            // 3. TOMBOL AKSI (Log In / Log Out)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleAuthAction,
                style: ElevatedButton.styleFrom(
                  // Hijau jika Login, Merah jika Logout
                  backgroundColor: isLoggedIn
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF10B981),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isLoggedIn ? "Log Out" : "Log In",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
