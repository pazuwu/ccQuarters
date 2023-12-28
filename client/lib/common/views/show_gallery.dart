import 'dart:typed_data';

import 'package:ccquarters/common/views/gallery.dart';
import 'package:flutter/material.dart';

Future showGallery(
  BuildContext context, {
  List<String> urls = const [],
  List<Uint8List> memoryPhotos = const [],
  int initialIndex = 0,
}) async {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => LayoutBuilder(
        builder: (context, contraints) => Gallery(
          imageUrls: urls,
          memoryPhotos: memoryPhotos,
          width: contraints.maxWidth,
          initialIndex: initialIndex,
        ),
      ),
    ),
  );
}
