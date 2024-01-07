import 'package:ccquarters/common/consts.dart';
import 'package:flutter/material.dart';

String getStringOfListWithCommaDivider(List<String> list) {
  String result = "";
  for (String s in list) {
    result += "$s, ";
  }
  return result.substring(0, result.length - 2);
}

buildWidgetsWithDivider(List<Widget> widgets) {
  List<Widget> result = [];

  for (int i = 0; i < widgets.length; i++) {
    result.add(widgets[i]);

    if (i != widgets.length - 1) {
      result.add(
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Divider(
            color: Colors.grey,
            height: 2,
          ),
        ),
      );
    }
  }

  return result;
}

double getPaddingSizeForMainPage(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.portrait
      ? smallPaddingSize
      : mediumPaddingSize;
}
