import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/common/inputs/input_decorator_form.dart';
import 'package:flutter/material.dart';

class AddAdditionalInfo extends StatefulWidget {
  const AddAdditionalInfo({super.key, required this.onAdd});

  final Function(String title, String info) onAdd;
  @override
  State<AddAdditionalInfo> createState() => _AddAdditionalInfoState();
}

class _AddAdditionalInfoState extends State<AddAdditionalInfo> {
    final formKey = GlobalKey<FormState>();
    String title = "", info = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    TextFormField(
                      key: const Key("additionalInfoTitleField"),
                      initialValue: "",
                      onSaved: (newValue) => title = newValue?.trim() ?? '',
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
                      onSaved: (newValue) => info = newValue?.trim() ?? '',
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
                          if (formKey.currentState!.validate()) {
                            Navigator.pop(context);
                            formKey.currentState!.save();
                            widget.onAdd(title, info);
                          }
                        },
                        child: const Text("Dodaj")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}