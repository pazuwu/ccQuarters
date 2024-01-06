import 'package:flutter/material.dart';

import 'package:ccquarters/common/inputs/radio_list.dart';
import 'package:ccquarters/model/virtual_tours/scene.dart';

class SceneFormModel {
  SceneFormModel({
    required this.name,
    required this.importType,
    required this.draft,
  });

  final String name;
  final ImportType importType;
  final bool draft;
}

enum ImportType {
  photos,
  photos360,
}

class SceneForm extends StatefulWidget {
  const SceneForm({super.key, this.scene});

  final Scene? scene;

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
    return SingleChildScrollView(
      child: Padding(
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
                  widget.scene == null
                      ? 'Wpisz nazwę sceny'
                      : 'Zmień nazwę sceny',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              TextFormField(
                initialValue: widget.scene?.name,
                onChanged: (value) => setState(() => _selectedName = value),
                validator: (value) =>
                    value == null || value.isEmpty ? "Wprowadź nazwę" : null,
              ),
              if (widget.scene == null) ...[
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
                  valueChanged: (newValue) => setState(() {
                    _selectedImport = newValue;
                  }),
                  titleBuilder: (value) => Text(_formatImportType(value)),
                ),
              ],
              const SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_selectedImport == ImportType.photos) ...[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(
                          SceneFormModel(
                            name: _selectedName,
                            importType: _selectedImport,
                            draft: true,
                          ),
                        );
                      },
                      child: const Text("Utwórz wersję roboczą"),
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                  ],
                  FilledButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: widget.scene != null
                        ? const Text('Zapisz')
                        : const Text('Utwórz'),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        Navigator.of(context).pop(
                          SceneFormModel(
                            name: _selectedName,
                            importType: _selectedImport,
                            draft: false,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
