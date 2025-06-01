import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;
  bool get isLoggedIn => user != null;

  Future<String?> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      print('Register error: ${e.code} - ${e.message}');
      if (e.code == 'email-already-in-use') return 'Email sudah digunakan.';
      if (e.code == 'weak-password') return 'Password terlalu lemah (minimal 6 karakter).';
      if (e.code == 'invalid-email') return 'Email tidak valid.';
      return e.message ?? 'Terjadi kesalahan tak terduga.';
    } catch (e) {
      print('Register unknown error: $e');
      return 'Terjadi kesalahan tidak terduga.';
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      print('Login error: ${e.code} - ${e.message}');
      if (e.code == 'user-not-found') return 'Email belum terdaftar.';
      if (e.code == 'wrong-password') return 'Password salah.';
      if (e.code == 'invalid-email') return 'Email tidak valid.';
      return e.message ?? 'Terjadi kesalahan tak terduga.';
    } catch (e) {
      print('Login unknown error: $e');
      return 'Terjadi kesalahan tidak terduga.';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}
