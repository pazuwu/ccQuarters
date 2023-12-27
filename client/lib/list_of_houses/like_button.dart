import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class LikeButtonWithTheme extends StatelessWidget {
  const LikeButtonWithTheme(
      {super.key, required this.isLiked, required this.onTap});

  final bool isLiked;
  final Future<bool?> Function(bool) onTap;

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
      size: 32,
      likeBuilder: (bool isLiked) {
        return Icon(
          Icons.favorite,
          color: isLiked ? Colors.red : Colors.grey,
          size: 32,
        );
      },
      onTap: onTap,
    );
  }
}
