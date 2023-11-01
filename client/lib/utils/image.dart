import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.imageUrl,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.fit = BoxFit.cover,
    this.shape = BoxShape.rectangle,
  });

  final String imageUrl;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fadeInDuration: const Duration(milliseconds: 700),
      placeholder: (context, text) {
        return const Center(child: CircularProgressIndicator());
      },
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: shape != BoxShape.circle ? borderRadius : null,
          shape: shape,
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      imageUrl: imageUrl,
    );
  }
}
