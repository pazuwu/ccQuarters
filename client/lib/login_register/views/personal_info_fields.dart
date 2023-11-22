import 'package:ccquarters/common_widgets/themed_form_field.dart';
import 'package:flutter/material.dart';


class PersonalInfoFields extends StatelessWidget {
  const PersonalInfoFields({
    super.key,
    required this.company,
    required this.name,
    required this.surname,
    required this.phoneNumber,
  });

  final TextEditingController company;
  final TextEditingController name;
  final TextEditingController surname;
  final TextEditingController phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ThemedFormField(
          controller: company,
          labelText: 'Firma',
        ),
        const SizedBox(
          height: 20,
        ),
        ThemedFormField(
          controller: name,
          labelText: 'Imię',
          validator: (text) {
            if (text == null || text.isEmpty) {
              return "Wprowadź imię";
            }
            return null;
          },
        ),
        const SizedBox(
          height: 20,
        ),
        ThemedFormField(
          controller: surname,
          labelText: 'Nazwisko',
          validator: (text) {
            if (text == null || text.isEmpty) {
              return "Wprowadź nazwisko";
            }
            return null;
          },
        ),
        const SizedBox(
          height: 20,
        ),
        ThemedFormField(
          controller: phoneNumber,
          labelText: 'Numer telefonu',
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}