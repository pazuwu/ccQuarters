import 'package:ccquarters/utils/radio_list.dart';
import 'package:flutter/material.dart';

enum ImportType {
  photos,
  photos360,
}

class ImportTypeDialog extends StatefulWidget {
  const ImportTypeDialog({super.key});

  @override
  State<ImportTypeDialog> createState() => _ImportTypeDialogState();
}

class _ImportTypeDialogState extends State<ImportTypeDialog> {
  ImportType? _selectedImport = ImportType.photos;

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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                Navigator.of(context).pop();
              },
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
        ],
      ),
    );
  }
}
