import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/common/inputs/input_decorator_form.dart';
import 'package:flutter/material.dart';

class AdditionalInfoForm extends StatefulWidget {
  const AdditionalInfoForm({
    super.key,
    required this.onSubmit,
    required this.title,
    required this.info,
  });

  final Function(String title, String info) onSubmit;
  final String title;
  final String info;

  @override
  State<AdditionalInfoForm> createState() => _AdditionalInfoFormState();
}

class _AdditionalInfoFormState extends State<AdditionalInfoForm> {
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
            top: 16.0,
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
                    initialValue: _title,
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
                    initialValue: _info,
                    onSaved: (newValue) => _info = newValue?.trim() ?? '',
                    decoration: createInputDecorationForForm(
                      context,
                      "Informacja",
                      isRequired: true,
                      alignLabelWithHint: true,
                    ),
                    minLines: 4,
                    maxLines: null,
                    validator: (value) =>
                        value?.isEmpty ?? false ? "Wpisz informację" : null,
                  ),
                ],
              ),
              const SizedBox(height: sizedBoxHeight),
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
                          widget.onSubmit(_title, _info);
                        }
                      },
                      child: const Text("Zapisz")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
