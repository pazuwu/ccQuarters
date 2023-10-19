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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
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

  late List<Scene> _filteredScenes;

  Scene? chosenScene;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    _filteredScenes = _scenes;

    _searchController.addListener(() {
      var searchedInLower = _searchController.text.toLowerCase();

      setState(() {
        _filteredScenes = _scenes
            .where((element) =>
                element.name.toLowerCase().contains(searchedInLower))
            .toList();
      });
    });

    _searchFocusNode.addListener(() {
      setState(() {
        _isSearching = _searchFocusNode.hasFocus;
      });
    });
  }

  Widget _buildSearchField(
      BuildContext context,
      TextEditingController controller,
      FocusNode focusNode,
      void Function() onFieldSubmitted) {
    return TextFormField(
      onFieldSubmitted: (text) => onFieldSubmitted(),
      controller: controller,
      focusNode: focusNode,
      textAlignVertical: TextAlignVertical.center,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          suffixIcon: _isSearching
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                  },
                  icon: const Icon(Icons.close),
                )
              : const Icon(Icons.search),
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          filled: true,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          hintText: "Szukaj sceny..."),
    );
  }

  _buildSceneList(BuildContext context) {
    return Flexible(
      child: FormField<Scene>(
        onSaved: (newValue) {},
        validator: (value) => value == null ? "Wybierz scenę docelową" : null,
        builder: (formFieldState) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Scrollbar(
                thumbVisibility: true,
                radius: const Radius.circular(8.0),
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredScenes.length,
                        itemBuilder: (context, index) {
                          return RadioListTile(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            selected: chosenScene == _filteredScenes[index],
                            selectedTileColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.65),
                            fillColor: MaterialStateColor.resolveWith((states) {
                              if (formFieldState.hasError) {
                                return Theme.of(context).colorScheme.error;
                              }

                              return Theme.of(context).colorScheme.primary;
                            }),
                            value: _filteredScenes[index],
                            groupValue: chosenScene,
                            onChanged: (newValue) {
                              setState(() {
                                _searchFocusNode.unfocus();
                                chosenScene = newValue;
                              });
                            },
                            title: Text(_filteredScenes[index].name),
                            secondary: TextButton.icon(
                                label: const Text("360°"),
                                onPressed: () {},
                                icon: const Icon(Icons.visibility)),
                          );
                        }),
                  ),
                ),
              ),
            ),
            if (formFieldState.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  formFieldState.errorText ?? "",
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              )
          ],
        ),
      ),
    );
  }

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSearchField(
              context, _searchController, _searchFocusNode, () {}),
          const SizedBox(
            height: 16.0,
          ),
          _buildSceneList(context),
        ],
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
