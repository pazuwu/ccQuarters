import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/common/inputs/input_decorator_form.dart';
import 'package:flutter/material.dart';

class AddAdditionalInfo extends StatefulWidget {
  const AddAdditionalInfo({
    super.key,
    required this.onAdd,
    required this.title,
    required this.info,
  });

  final Function(String title, String info) onAdd;
  final String title;
  final String info;

  @override
  State<AddAdditionalInfo> createState() => _AddAdditionalInfoState();
}

class _AddAdditionalInfoState extends State<AddAdditionalInfo> {
  final _formKey = GlobalKey<FormState>();
  late String _title, _info;

  @override
  void initState() {
    _title = widget.title;
    _info = widget.info;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  TextFormField(
                    key: const Key("additionalInfoTitleField"),
                    initialValue: "",
                    onSaved: (newValue) => _title = newValue?.trim() ?? '',
                    decoration: createInputDecorationForForm(
                      context,
                      "Tytuł",
                      isRequired: true,
                    ),
                    validator: (value) => value?.isEmpty ?? false
                        ? "Wpisz tytuł dodatkowej informacji"
                        : null,
                  ),
                  const SizedBox(height: sizedBoxHeight),
                  TextFormField(
                    key: const Key("additionalInfoField"),
                    initialValue: "",
                    onSaved: (newValue) => _info = newValue?.trim() ?? '',
                    decoration: createInputDecorationForForm(
                      context,
                      "Informacja",
                      isRequired: true,
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? false ? "Wpisz informację" : null,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Anuluj")),
                  TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          _formKey.currentState!.save();
                          widget.onAdd(_title, _info);
                        }
                      },
                      child: const Text("Dodaj")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
