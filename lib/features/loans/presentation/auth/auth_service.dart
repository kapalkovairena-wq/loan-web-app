import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ===== EMAIL AUTH =====
  Future<UserCredential> signInWithEmail(
      String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> registerWithEmail(
      String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await cred.user!.sendEmailVerification();
    return cred;
  }

  // ===== GOOGLE AUTH (WEB OFFICIEL) =====
  Future<UserCredential> signInWithGoogle() async {
    final GoogleAuthProvider googleProvider = GoogleAuthProvider();
    googleProvider.addScope('email');
    googleProvider.addScope('profile');

    return await _auth.signInWithPopup(googleProvider);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
