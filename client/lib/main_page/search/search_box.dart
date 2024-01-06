import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/common/functions.dart';
import 'package:ccquarters/common/widgets/shadow.dart';
import 'package:flutter/material.dart';

class FakeSearchBox extends StatelessWidget {
  const FakeSearchBox({
    super.key,
    required this.color,
    required this.onTap,
  });

  final ColorScheme color;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.all(getPaddingSizeForMainPage(context)),
        child: SearchBoxTheme(
          color: color,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            child: IgnorePointer(
              child: TextField(
                textAlignVertical:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? TextAlignVertical.bottom
                        : TextAlignVertical.center,
                decoration: buildSearchBoxDecoration(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBox extends StatefulWidget {
  const SearchBox({
    super.key,
    required this.color,
    required this.controller,
    required this.onSubmitted,
  });

  final ColorScheme color;
  final TextEditingController controller;
  final Function(String)? onSubmitted;

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  bool _showClearButton = false;

  @override
  void initState() {
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {
          _showClearButton = widget.controller.text.isNotEmpty;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBoxTheme(
      color: widget.color,
      child: TextField(
        autofocus: true,
        textAlignVertical: MediaQuery.of(context).orientation == Orientation.portrait
            ? TextAlignVertical.bottom
            : TextAlignVertical.center,
        controller: widget.controller,
        decoration: buildSearchBoxDecoration(
          onPressed: () {
            widget.controller.clear();
            if (widget.onSubmitted != null) widget.onSubmitted!("");
          },
          showClearButton: _showClearButton,
        ),
        onChanged: (value) => {},
        onSubmitted: widget.onSubmitted,
        textInputAction: TextInputAction.search,
      ),
    );
  }
}

class SearchBoxTheme extends StatelessWidget {
  const SearchBoxTheme({
    super.key,
    required this.color,
    required this.child,
  });

  final ColorScheme color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: MediaQuery.of(context).orientation == Orientation.portrait
            ? portraitSearchBoxHeight
            : landscapeSearchBoxHeight,
      ),
      child: Shadow(color: color, child: child),
    );
  }
}

InputDecoration buildSearchBoxDecoration(
    {Function()? onPressed, bool showClearButton = false}) {
  return InputDecoration(
    hintText: "Szukaj...",
    border: InputBorder.none,
    prefixIcon: const Padding(
      padding: EdgeInsets.all(largePaddingSize),
      child: Icon(Icons.search, size: iconSize),
    ),
    suffixIcon: showClearButton
        ? IconButton(
            padding: const EdgeInsets.all(largePaddingSize),
            icon: const Icon(Icons.clear, size: iconSize),
            onPressed: onPressed,
          )
        : null,
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(borderRadius),
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(borderRadius),
      ),
    ),
  );
}
