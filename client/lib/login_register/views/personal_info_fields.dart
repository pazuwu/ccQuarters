import 'package:ccquarters/common/inputs/themed_form_field.dart';
import 'package:ccquarters/common/views/center_view_with_constraints.dart';
import 'package:flutter/material.dart';

class PersonalInfoFields extends StatefulWidget {
  const PersonalInfoFields({
    super.key,
    required this.company,
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.isBusinessAccount,
    this.onLastFieldSubmitted,
    this.saveIsBusinessAcount,
  });

  final TextEditingController company;
  final TextEditingController name;
  final TextEditingController surname;
  final TextEditingController phoneNumber;
  final bool isBusinessAccount;
  final Function? saveIsBusinessAcount;
  final Function? onLastFieldSubmitted;

  @override
  State<PersonalInfoFields> createState() => _PersonalInfoFieldsState();
}

class _PersonalInfoFieldsState extends State<PersonalInfoFields> {
  late bool _isBusinessAccount;

  @override
  void initState() {
    _isBusinessAccount = widget.isBusinessAccount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CenterViewWithConstraints(
      widthMultiplier: 0.4,
      child: Column(
        children: [
          _buildBusinessAccountSwitch(context),
          if (_isBusinessAccount) _buildCompanyField(),
          _buildNameField(),
          const SizedBox(
            height: 20,
          ),
          _buildSurnameField(),
          const SizedBox(
            height: 20,
          ),
          _buildPhoneNumberField(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessAccountSwitch(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.business_center_outlined,
        color: _isBusinessAccount ? Colors.black : Colors.grey,
      ),
      title: Text(
        "Konto firmowe",
        style: TextStyle(
          color: _isBusinessAccount ? Colors.black : Colors.grey,
        ),
      ),
      trailing: Switch(
        value: _isBusinessAccount,
        onChanged: (value) {
          widget.saveIsBusinessAcount?.call(value);
          setState(() {
            _isBusinessAccount = value;
          });
        },
      ),
    );
  }

  Column _buildCompanyField() {
    return Column(
      children: [
        ThemedFormField(
          controller: widget.company,
          labelText: 'Firma',
          validator: (text) {
            if (text == null || text.isEmpty) {
              return "Wprowadź nazwę firmy";
            }
            return null;
          },
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  ThemedFormField _buildNameField() {
    return ThemedFormField(
      controller: widget.name,
      labelText: 'Imię',
      validator: (text) {
        if (!_isBusinessAccount) {
          if (text == null || text.isEmpty) {
            return "Wprowadź imię";
          }
          return null;
        } else {
          if ((text == null || text.isEmpty) &&
              widget.surname.text.isNotEmpty) {
            return "Wprowadź imię";
          }
          return null;
        }
      },
    );
  }

  ThemedFormField _buildSurnameField() {
    return ThemedFormField(
      controller: widget.surname,
      labelText: 'Nazwisko',
      validator: (text) {
        if (!_isBusinessAccount) {
          if (text == null || text.isEmpty) {
            return "Wprowadź nazwisko";
          }
          return null;
        } else {
          if ((text == null || text.isEmpty) && widget.name.text.isNotEmpty) {
            return "Wprowadź nazwisko";
          }
          return null;
        }
      },
    );
  }

  ThemedFormField _buildPhoneNumberField() {
    return ThemedFormField(
      controller: widget.phoneNumber,
      labelText: 'Numer telefonu',
      onFieldSubmitted: widget.onLastFieldSubmitted != null
          ? (text) {
              widget.onLastFieldSubmitted!();
            }
          : null,
    );
  }
}
