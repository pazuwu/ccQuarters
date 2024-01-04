import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class LikeButtonWithTheme extends StatelessWidget {
  const LikeButtonWithTheme(
      {super.key, required this.isLiked, required this.onTap, this.size = 32});

  final bool isLiked;
  final Future<bool?> Function(bool) onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      bubblesColor: const BubblesColor(
          dotPrimaryColor: Colors.red,
          dotSecondaryColor: Colors.redAccent,
          dotThirdColor: Colors.redAccent,
          dotLastColor: Colors.redAccent),
      circleSize: 0,
      isLiked: isLiked,
      size: size,
      likeBuilder: (bool isLiked) {
        return Icon(
          Icons.favorite,
          color: isLiked ? Colors.red : Colors.grey,
          size: size,
        );
      },
      onTap: onTap,
    );
  }
}
