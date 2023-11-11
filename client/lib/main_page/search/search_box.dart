import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/common_widgets/shadow.dart';
import 'package:ccquarters/utils/device_type.dart';
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
                textAlignVertical: getDeviceType(context) == DeviceType.mobile
                    ? TextAlignVertical.bottom
                    : TextAlignVertical.center,
                decoration: const InputDecoration(
                  hintText: "Szukaj...",
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(borderRadius),
                    ),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(largePaddingSize),
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
    required this.onSubmitted,
  });

  final ColorScheme color;
  final TextEditingController controller;
  final Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SearchBoxTheme(
      color: color,
      child: TextField(
        autofocus: true,
        textAlignVertical: getDeviceType(context) == DeviceType.mobile
            ? TextAlignVertical.bottom
            : TextAlignVertical.center,
        controller: controller,
        decoration: InputDecoration(
          hintText: "Szukaj...",
          border: InputBorder.none,
          prefixIcon: const Padding(
            padding: EdgeInsets.all(largePaddingSize),
            child: Icon(Icons.search, size: iconSize),
          ),
          suffixIcon: IconButton(
            padding: const EdgeInsets.all(largePaddingSize),
            icon: const Icon(Icons.clear, size: iconSize),
            onPressed: () {
              controller.clear();
            },
          ),
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
        ),
        onChanged: (value) => {},
        onSubmitted: onSubmitted,
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
        maxHeight: getDeviceType(context) == DeviceType.mobile
            ? mobileSearchBoxHeight
            : webSearchBoxHeight,
      ),
      child: Shadow(color: color, child: child),
    );
  }
}
