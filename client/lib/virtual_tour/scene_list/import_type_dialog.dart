import 'package:flutter/material.dart';

import 'package:ccquarters/common_widgets/radio_list.dart';

class SceneFormModel {
  SceneFormModel({
    required this.name,
    required this.importType,
  });
  String name;
  ImportType importType;
}

enum ImportType {
  photos,
  photos360,
}

class SceneForm extends StatefulWidget {
  const SceneForm({super.key});

  @override
  State<SceneForm> createState() => _SceneFormState();
}

class _SceneFormState extends State<SceneForm> {
  ImportType _selectedImport = ImportType.photos;
  String _selectedName = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _formatImportType(ImportType importType) {
    switch (importType) {
      case ImportType.photos:
        return "Zdjęcia";
      case ImportType.photos360:
        return "Zdjęcia 360°";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Wpisz nazwę sceny',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            TextFormField(
              initialValue: "",
              onChanged: (value) => setState(() => _selectedName = value),
              validator: (value) =>
                  value == null || value.isEmpty ? "Wprowadź nazwę" : null,
            ),
            const SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Wybierz rodzaj importu',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            RadioListForm(
              defaultValue: _selectedImport,
              values: ImportType.values,
              valueChanged: (newValue) => _selectedImport = newValue,
              titleBuilder: (value) => Text(_formatImportType(value)),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Align(
              alignment: Alignment.topRight,
              child: FilledButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Dalej'),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Navigator.of(context).pop(
                      SceneFormModel(
                        name: _selectedName,
                        importType: _selectedImport,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
          ],
        ),
      ),
    );
  }
}
