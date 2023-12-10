import 'package:flutter/material.dart';

class ThemedFormField extends StatelessWidget {
  const ThemedFormField(
      {super.key,
      this.obscureText = false,
      this.controller,
      this.labelText,
      this.validator});

  final bool obscureText;
  final TextEditingController? controller;
  final String? labelText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        errorMaxLines: 2,
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!, width: 1.5),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!, width: 1.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!, width: 1.5),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error, width: 1.5),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error, width: 1.5),
        ),
        fillColor: Colors.white,
        labelText: labelText,
      ),
      validator: validator,
    );
  }
}
