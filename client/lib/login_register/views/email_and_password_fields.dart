import 'package:ccquarters/common_widgets/themed_form_field.dart';
import 'package:flutter/material.dart';

class EmailAndPasswordFields extends StatelessWidget {
  const EmailAndPasswordFields({
    super.key,
    required this.email,
    required this.password,
    this.repeatPassword,
  });

  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController? repeatPassword;

  @override
  Widget build(BuildContext context) {
    final RegExp emailRegExp =
        RegExp("(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+\$)");
    return Column(
      children: [
        ThemedFormField(
          controller: email,
          labelText: 'E-mail',
          validator: (text) {
            if (text == null || text.isEmpty) {
              return "Wprowadź adres e-mail";
            }
            if (!emailRegExp.hasMatch(text)) {
              return "Niepoprawny adres email";
            }
            return null;
          },
        ),
        const SizedBox(
          height: 20,
        ),
        ThemedFormField(
          controller: password,
          obscureText: true,
          labelText: 'Hasło',
          validator: (text) {
            if (text == null || text.isEmpty) {
              return "Wprowadź hasło";
            }
            return null;
          },
        ),
        if (repeatPassword != null)
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              ThemedFormField(
                controller: repeatPassword,
                obscureText: true,
                labelText: 'Powtórz hasło',
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "Powtórz hasło";
                  }

                  if (repeatPassword!.text != password.text) {
                    return "Hasła nie są takie same";
                  }

                  return null;
                },
              ),
            ],
          )
      ],
    );
  }
}