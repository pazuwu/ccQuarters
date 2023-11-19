import 'package:firebase_auth/firebase_auth.dart';

import 'sign_in_result.dart';
import 'sign_up_result.dart';

class AuthService {
  const AuthService({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;

  bool get isSignedIn => _firebaseAuth.currentUser != null;
  Stream<bool> get isSignedInStream =>
      _firebaseAuth.userChanges().map((user) => user != null);
  String get userEmail => _firebaseAuth.currentUser!.email!;
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  Future<String?> getToken() async {
    return await _firebaseAuth.currentUser?.getIdToken();
  }

   Future<SignInResult> signInAnnonymously() async {
    await _firebaseAuth.signInAnonymously();
    return SignInResult.success;
  }

  Future<SignInResult> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      if (isSignedIn) {
        await _firebaseAuth.signOut();
      }

      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return SignInResult.success;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return SignInResult.invalidEmail;
        case 'email-already-in-use':
          return SignInResult.emailAlreadyInUse;
        case 'user-disabled':
          return SignInResult.userDisabled;
        case 'user-not-found':
          return SignInResult.userNotFound;
        case 'wrong-password':
          return SignInResult.wrongPassword;
        default:
          rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<SignUpResult> signUp(
    String email,
    String password,
  ) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      return SignUpResult.success;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return SignUpResult.invalidEmail;
        case 'email-already-in-use':
          return SignUpResult.emailAlreadyInUse;
        case 'operation-not-allowed':
          return SignUpResult.operationNotAllowed;
        case 'weak-password':
          return SignUpResult.weakPassword;
        default:
          rethrow;
      }
    }
  }

  Future<void> signOut() => _firebaseAuth.signOut();
}
