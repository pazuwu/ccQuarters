import 'package:ccquarters/common/consts.dart';
import 'package:flutter/material.dart';

enum DeviceType {
  mobile,
  web,
}

DeviceType getDeviceType(BuildContext context) {
  return MediaQuery.of(context).size.width <= maxWidth
      ? DeviceType.mobile
      : DeviceType.web;
}

DeviceType getDeviceTypeForGrid(BuildContext context) {
  return MediaQuery.of(context).size.width <= maxWidthForGrid
      ? DeviceType.mobile
      : DeviceType.web;
}

double getPaddingSizeForMainPage(BuildContext context) {
  return getDeviceType(context) == DeviceType.mobile
      ? smallPaddingSize
      : mediumPaddingSize;
}
