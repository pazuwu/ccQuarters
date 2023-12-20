import 'package:ccquarters/services/auth/auth_info.dart';
import 'package:ccquarters/services/auth/service.dart';
import 'package:ccquarters/services/auth/sign_in_result.dart';
import 'package:ccquarters/services/auth/sign_up_result.dart';

class AuthServiceMock extends BaseAuthService {
  AuthServiceMock({required bool isSignedIn}) : _isSignedIn = isSignedIn;

  final bool _isSignedIn;

  @override
  bool get isSignedIn => _isSignedIn;
  @override
  String? get currentUserId => "cb849fa2-1033-4d6b-7c88-08db36d6f10f";

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
  Stream<AuthInfo> get authChanges => throw UnimplementedError();
}
