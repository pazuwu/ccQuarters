import 'package:ccquarters/services/auth/auth_info.dart';
import 'package:ccquarters/services/auth/reset_password_result.dart';
import 'package:ccquarters/services/auth/service.dart';
import 'package:ccquarters/services/auth/sign_in_result.dart';
import 'package:ccquarters/services/auth/sign_up_result.dart';

import 'mock_data.dart';

class AuthServiceMock extends BaseAuthService {
  AuthServiceMock({required bool isSignedIn}) : _isSignedIn = isSignedIn;

  final bool _isSignedIn;

  @override
  bool get isSignedIn => _isSignedIn;
  @override
  String? get currentUserId => mockId;
  @override
  String? get currentUserEmail => mockEmail;

  @override
  Future<String?> getToken() async {
    return "Bearer ";
  }

  @override
  Future<SignInResult> signInAnnonymously() async {
    return SignInResult.success;
  }

  @override
  Future<SignInResult> signInWithEmail(
    String email,
    String password,
  ) async {
    return SignInResult.success;
  }

  @override
  Future<SignUpResult> signUp(
    String email,
    String password,
  ) async {
    return SignUpResult.success;
  }

  @override
  Future<void> signOut() {
    return Future(() => null);
  }

  @override
  Future<ResetPasswordResult> sendPasswordResetEmail(String email) {
    return Future(() => ResetPasswordResult.success);
  }

  @override
  Stream<AuthInfo> get authChanges => throw UnimplementedError();
}
