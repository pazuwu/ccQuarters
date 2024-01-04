enum SignInResult {
  invalidEmail,
  userDisabled,
  userNotFound,
  emailAlreadyInUse,
  wrongPassword,
  invalidCredential,
  success;

  @override
  String toString() => name;
}

extension SignInResultEx on SignInResult {
  String get name {
    switch (this) {
      case SignInResult.invalidEmail:
        return "Niepoprawny adres e-mail";
      case SignInResult.userDisabled:
        return "Użytkownik został zablokowany";
      case SignInResult.userNotFound:
        return "Nie znaleziono użytkownika. Sprawdź wprowadzone dane";
      case SignInResult.emailAlreadyInUse:
        return "E-mail jest już w użyciu";
      case SignInResult.wrongPassword:
        return "E-mail i hasło nie pasują. Sprawdź wprowadzone dane";
      case SignInResult.invalidCredential:
        return "Niepoprawny e-mail lub hasło";
      case SignInResult.success:
        return "Zalogowano";
    }
  }
}
