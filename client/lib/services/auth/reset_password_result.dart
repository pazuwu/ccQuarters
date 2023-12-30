enum ResetPasswordResult {
  invalidEmail,
  userNotFound,
  unknownError,
  success;

  @override
  String toString() => name;
}

extension SignInResultEx on ResetPasswordResult {
  String get name {
    switch (this) {
      case ResetPasswordResult.invalidEmail:
        return "Niepoprawny adres e-mail";
      case ResetPasswordResult.userNotFound:
        return "Nie znaleziono użytkownika. Sprawdź wprowadzone dane";
      case ResetPasswordResult.success:
        return "Wysłano link do resetu hasła";
      case ResetPasswordResult.unknownError:
        return "Nieoczekiwany błąd";
    }
  }
}
