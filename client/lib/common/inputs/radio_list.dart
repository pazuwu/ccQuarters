import 'package:flutter/material.dart';

class RadioListForm<T> extends StatefulWidget {
  const RadioListForm({
    Key? key,
    required this.values,
    this.filter,
    this.titleBuilder,
    this.secondaryBuilder,
    this.validator,
    this.searchBoxHintText,
    this.defaultValue,
    this.valueChanged,
    this.onSaved,
  }) : super(key: key);

  final List<T> values;
  final List<T> Function(Iterable<T>, String phrase)? filter;
  final Widget Function(T)? titleBuilder;
  final Widget Function(T)? secondaryBuilder;
  final String? Function(T?)? validator;
  final String? searchBoxHintText;
  final T? defaultValue;
  final void Function(T)? valueChanged;
  final void Function(T?)? onSaved;

  @override
  State<RadioListForm> createState() => _RadioListFormState<T>();
}

class _RadioListFormState<T> extends State<RadioListForm<T>> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late List<T> _filteredValues;
  T? _chosenValue;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    _filteredValues = widget.values;
    _chosenValue = widget.defaultValue;

    if (widget.filter != null) {
      _searchController.addListener(() {
        var searchedInLower = _searchController.text.toLowerCase();

        setState(() {
          _filteredValues = widget.filter!(widget.values, searchedInLower);
        });
      });
    }

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
        hintText: widget.searchBoxHintText,
      ),
    );
  }

  _buildSceneList(BuildContext context) {
    return Flexible(
      child: FormField<T>(
        initialValue: _chosenValue,
        onSaved: widget.onSaved,
        validator: widget.validator,
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
                    child: _filteredValues.isEmpty
                        ? const Text("Brak wyników")
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filteredValues.length,
                            itemBuilder: (context, index) {
                              return RadioListTile(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                selected:
                                    _chosenValue == _filteredValues[index],
                                selectedTileColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.65),
                                fillColor:
                                    MaterialStateColor.resolveWith((states) {
                                  if (formFieldState.hasError) {
                                    return Theme.of(context).colorScheme.error;
                                  }

                                  return Theme.of(context).colorScheme.primary;
                                }),
                                value: _filteredValues[index],
                                groupValue: _chosenValue,
                                onChanged: (newValue) {
                                  formFieldState.didChange(newValue);
                                  setState(() {
                                    _searchFocusNode.unfocus();
                                    _chosenValue = newValue;
                                    if (newValue != null) {
                                      widget.valueChanged?.call(newValue);
                                    }
                                  });
                                },
                                title: widget.titleBuilder
                                    ?.call(_filteredValues[index]),
                                secondary: widget.secondaryBuilder
                                    ?.call(_filteredValues[index]),
                              );
                            },
                          ),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.filter != null)
          _buildSearchField(
              context, _searchController, _searchFocusNode, () {}),
        if (widget.filter != null)
          const SizedBox(
            height: 16.0,
          ),
        _buildSceneList(context),
      ],
    );
  }
}
