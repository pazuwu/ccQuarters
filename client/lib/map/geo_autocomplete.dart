import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class GeoAutocompleteController implements Listenable {
  List<VoidCallback> listeners = [];

  TextEditingController? _textEditingController;
  FocusNode? _focusNode;
  SearchInfo? _searchInfo;

  SearchInfo? get searchInfo => _searchInfo;
  bool get hasFocus => _focusNode?.hasFocus ?? false;

  set location(GeoPoint? location) {
    _textEditingController?.text =
        "${location?.longitude}, ${location?.latitude}";
  }

  @override
  void addListener(VoidCallback listener) {
    listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    listeners.remove(listener);
  }

  void unfocus() {
    _focusNode?.unfocus();
  }

  void _registerAutocompleteControllers(
      {required TextEditingController editingController,
      required FocusNode focusNode}) {
    _textEditingController = editingController;
    _focusNode = focusNode;
  }

  void _publishNewSearchInfo(SearchInfo? newValue) {
    _searchInfo = newValue;

    for (var listener in listeners) {
      listener();
    }
  }
}

class GeoAutocomplete extends StatefulWidget {
  const GeoAutocomplete({
    Key? key,
    this.controller,
    this.criticalWidth,
    this.maxSuggestionsHeight,
    this.padding,
  }) : super(key: key);

  final GeoAutocompleteController? controller;
  final double? criticalWidth;
  final double? maxSuggestionsHeight;
  final EdgeInsets? padding;

  @override
  State<GeoAutocomplete> createState() => _GeoAutocompleteState();
}

class _GeoAutocompleteState extends State<GeoAutocomplete> {
  bool hasFocus = false;

  FutureOr<Iterable<SearchInfo>> _searchSuggestions(
      TextEditingValue value) async {
    List<SearchInfo> suggestions = await addressSuggestion(value.text);

    return suggestions;
  }

  String _selectedValueToInputString(SearchInfo suggestion) {
    return suggestion.address?.toString() ?? "";
  }

  Widget _buildInput(BuildContext context, TextEditingController controller,
      FocusNode focusNode, void Function() onFieldSubmitted) {
    widget.controller?._registerAutocompleteControllers(
        editingController: controller, focusNode: focusNode);

    focusNode.addListener(() {
      setState(() {
        hasFocus = focusNode.hasFocus;
      });
    });

    return PointerInterceptor(
      child: TextFormField(
        onFieldSubmitted: (text) => onFieldSubmitted(),
        controller: controller,
        focusNode: focusNode,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: hasFocus
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        widget.controller?._textEditingController?.clear();
                        widget.controller?._publishNewSearchInfo(null);
                      },
                    )
                  : const Icon(Icons.search),
            ),
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            filled: true,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            hintText: "Szukaj lokalizacji..."),
      ),
    );
  }

  Widget _buildSuggestions(
      BuildContext context,
      AutocompleteOnSelected<SearchInfo> onSelected,
      Iterable<SearchInfo> options,
      {required double maxWidth,
      required double maxHeight}) {
    return Padding(
      padding:
          EdgeInsets.only(top: 4.0, right: 2 * (widget.padding?.right ?? 0.0)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: maxWidth),
          child: PointerInterceptor(
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                final SearchInfo suggestion = options.elementAt(index);
                return _buildSuggestion(suggestion, onSelected);
              },
            ),
          ),
        ),
      ),
    );
  }

  Column _buildSuggestion(
      SearchInfo suggestion, AutocompleteOnSelected<SearchInfo> onSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          enableFeedback: true,
          dense: true,
          title: Text(_selectedValueToInputString(suggestion)),
          onTap: () {
            onSelected(suggestion);
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Divider(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(0.0),
      child: LayoutBuilder(builder: (context, constraints) {
        var maxWidth = widget.criticalWidth == null
            ? double.infinity
            : min(constraints.maxWidth, widget.criticalWidth!);

        var maxHeight =
            min(widget.maxSuggestionsHeight ?? 200.0, constraints.maxHeight);

        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: PointerInterceptor(
            child: Autocomplete<SearchInfo>(
              optionsBuilder: _searchSuggestions,
              displayStringForOption: _selectedValueToInputString,
              onSelected: (newValue) {
                widget.controller?.unfocus();
                widget.controller?._publishNewSearchInfo(newValue);
              },
              fieldViewBuilder: _buildInput,
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<SearchInfo> onSelected,
                  Iterable<SearchInfo> options) {
                return _buildSuggestions(context, onSelected, options,
                    maxWidth: maxWidth, maxHeight: maxHeight);
              },
            ),
          ),
        );
      }),
    );
  }
}
