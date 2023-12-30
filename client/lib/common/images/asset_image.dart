import 'package:flutter/material.dart';

class AssetImageWidget extends StatelessWidget {
  const AssetImageWidget({
    super.key,
    required this.imagePath,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.fit = BoxFit.cover,
    this.shape = BoxShape.rectangle,
    this.height,
  });

  final String imagePath;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final BoxShape shape;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: shape != BoxShape.circle ? borderRadius : null,
        shape: shape,
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: fit,
        ),
      ),
    );
  }
}
