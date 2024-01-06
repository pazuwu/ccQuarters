import 'package:ccquarters/model/virtual_tour/tour_info.dart';
import 'package:flutter/material.dart';

class TourForm extends StatefulWidget {
  const TourForm({super.key, this.tourInfo});

  final TourInfo? tourInfo;

  @override
  State<TourForm> createState() => _ImportTypeDialogState();
}

class _ImportTypeDialogState extends State<TourForm> {
  String _tourName = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tourName = widget.tourInfo?.name ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom),
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
                widget.tourInfo != null ? 'Edycja spaceru' : 'Nowy spacer',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            TextFormField(
              initialValue: _tourName,
              decoration: const InputDecoration(
                labelText: "Nazwa",
              ),
              onChanged: (value) => _tourName = value,
              validator: (value) => (value?.isEmpty ?? true)
                  ? "Wpisz nazwę wirtualnego spaceru"
                  : null,
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
                    _formKey.currentState?.save();
                    Navigator.of(context).pop(_tourName);
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
