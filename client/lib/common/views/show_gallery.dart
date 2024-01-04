import 'dart:typed_data';

import 'package:ccquarters/common/views/gallery.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future showGallery(
  BuildContext context, {
  List<String> urls = const [],
  List<Uint8List> memoryPhotos = const [],
  int initialIndex = 0,
}) async {
  return context.push(
    '/gallery',
    extra: GalleryParameters(
      imageUrls: urls,
      memoryPhotos: memoryPhotos,
      initialIndex: initialIndex,
    ),
  );
}
