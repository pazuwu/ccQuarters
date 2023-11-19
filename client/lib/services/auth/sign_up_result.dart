enum SignUpResult {
  invalidEmail,
  emailAlreadyInUse,
  operationNotAllowed,
  weakPassword,
  success,
}

extension SignUpResultEx on SignUpResult {
  String get name {
    switch (this) {
      case SignUpResult.invalidEmail:
        return "Niepoprawny adres e-mail";
      case SignUpResult.emailAlreadyInUse:
        return "E-mail jest już w użyciu";
      case SignUpResult.operationNotAllowed:
        return "Operacja nie jest dozwolona";
      case SignUpResult.weakPassword:
        return "Hasło jest za słabe";
      case SignUpResult.success:
        return "Zarejestrowano";
    }
  }
}
