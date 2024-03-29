import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/common/inputs/themed_form_field.dart';
import 'package:ccquarters/common/views/constrained_center_box.dart';
import 'package:flutter/material.dart';

class EmailAndPasswordFields extends StatelessWidget {
  const EmailAndPasswordFields({
    super.key,
    required this.email,
    required this.password,
    required this.onLastFieldSubmitted,
    this.repeatPassword,
  });

  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController? repeatPassword;
  final Function() onLastFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return ConstrainedCenterBox(
      widthMultiplier: 0.4,
      child: Column(
        children: [
          _buildEmailField(),
          const SizedBox(
            height: 20,
          ),
          _buildPasswordField(),
          if (repeatPassword != null) _buildRepeatPasswordField()
        ],
      ),
    );
  }

  ThemedFormField _buildEmailField() {
    final RegExp emailRegExp = RegExp(emailRegExpString);

    return ThemedFormField(
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
    );
  }

  ThemedFormField _buildPasswordField() {
    return ThemedFormField(
      controller: password,
      obscureText: true,
      labelText: 'Hasło',
      validator: (text) {
        if (text == null || text.isEmpty) {
          return "Wprowadź hasło";
        }
        return null;
      },
      onFieldSubmitted: repeatPassword != null
          ? null
          : (text) {
              onLastFieldSubmitted();
            },
    );
  }

  Column _buildRepeatPasswordField() {
    return Column(
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
          onFieldSubmitted: (text) {
            onLastFieldSubmitted();
          },
        ),
      ],
    );
  }
}
