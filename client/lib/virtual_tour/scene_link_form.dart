import 'package:ccquarters/utils/icon_360.dart';
import 'package:ccquarters/utils/radio_list.dart';
import 'package:flutter/material.dart';

import 'package:ccquarters/utils/input_decorator_form.dart';
import 'package:ccquarters/virtual_tour/scene.dart';

enum SceneLinkFormType {
  edit,
  create,
}

class SceneLinkForm extends StatefulWidget {
  const SceneLinkForm({
    Key? key,
    this.formType = SceneLinkFormType.create,
  }) : super(key: key);

  final SceneLinkFormType formType;

  @override
  State<SceneLinkForm> createState() => _SceneLinkFormState();
}

class _SceneLinkFormState extends State<SceneLinkForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<Scene> _scenes = [
    Scene(name: "Sypialnia", url: ""),
    Scene(name: "Sypialnia", url: ""),
    Scene(name: "Sypialnia", url: ""),
    Scene(name: "Sypialnia", url: ""),
    Scene(name: "Sypialnia", url: ""),
    Scene(name: "Sypialnia", url: ""),
    Scene(name: "Sypialnia", url: ""),
    Scene(name: "Sypialnia", url: ""),
    Scene(name: "Sypialnia", url: ""),
    Scene(name: "Sypialnia", url: ""),
    Scene(name: "Sypialnia", url: ""),
    Scene(name: "Sypialnia", url: ""),
    Scene(name: "Sypialnia", url: ""),
    Scene(name: "Sypialnia", url: ""),
    Scene(name: "Sypialnia", url: ""),
    Scene(name: "Łazienka", url: "")
  ];

  Widget _buildTitle(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 16.0,
        ),
        Text(
          widget.formType == SceneLinkFormType.create
              ? "Tworzenie nowego łącznika"
              : "Edycja łącznika",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(
          height: 64.0,
        ),
      ],
    );
  }

  Widget _buildNameField(BuildContext context) {
    return TextFormField(
      onSaved: (value) {},
      validator: (value) =>
          value?.isEmpty ?? false ? "Podaj nazwę łącznika" : null,
      decoration:
          createInputDecorationForForm(context, "Nazwa", isRequired: true),
    );
  }

  Widget _buildSceneSelectionField(BuildContext context) {
    return Flexible(
      child: RadioListForm(
        values: _scenes,
        defaultValue: _scenes.first,
        filter: (scenes, text) {
          var textInLowerCase = text.toLowerCase();

          return scenes
              .where(
                  (scene) => scene.name.toLowerCase().contains(textInLowerCase))
              .toList();
        },
        searchBoxHintText: "Szukaj sceny...",
        validator: (scene) => scene == null ? "Wybierz scenę docelową" : null,
        titleBuilder: (scene) => Text(scene.name),
        secondaryBuilder: (scene) => const Icon360(),
        onSaved: (scene) {},
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: FilledButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            _formKey.currentState?.save();
          }
        },
        child: const Text("Zapisz"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(context),
                _buildNameField(context),
                const SizedBox(
                  height: 24.0,
                ),
                _buildSceneSelectionField(context),
                const SizedBox(
                  height: 16.0,
                ),
                _buildSaveButton(context),
                const SizedBox(
                  height: 16.0,
                ),
              ],
            ),
          ),
        ));
  }
}
