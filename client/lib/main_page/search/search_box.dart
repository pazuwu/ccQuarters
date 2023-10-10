import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/utils/shadow.dart';
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
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: SearchBoxTheme(
          color: color,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            child: const IgnorePointer(
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: "Szukaj...",
                  border: InputBorder.none,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(paddingSize),
                    child: Icon(Icons.search, size: iconSize),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
    required this.color,
    required this.controller,
  });

  final ColorScheme color;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SearchBoxTheme(
      color: color,
      child: TextField(
        autofocus: true,
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        decoration: InputDecoration(
          hintText: "Szukaj...",
          border: InputBorder.none,
          prefixIcon: const Padding(
            padding: EdgeInsets.all(paddingSize),
            child: Icon(Icons.search, size: iconSize),
          ),
          suffixIcon: IconButton(
            padding: const EdgeInsets.all(paddingSize),
            icon: const Icon(Icons.clear, size: iconSize),
            onPressed: () {
              controller.clear();
            },
          ),
        ),
        onChanged: (value) => {},
        onSubmitted: (value) => {},
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
      constraints: const BoxConstraints(
        maxWidth: maxWidth,
        minHeight: minHeight,
      ),
      child: Shadow(color: color, child: child),
    );
  }
}
