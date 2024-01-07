import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/common/images/image.dart';
import 'package:flutter/material.dart';

class ContactPhoto extends StatelessWidget {
  const ContactPhoto({super.key, required this.width, this.photoUrl});

  final double width;
  final String? photoUrl;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: width,
      ),
      child: Padding(
        padding: const EdgeInsets.all(largePaddingSize),
        child: photoUrl != null
            ? ImageWidget(
                imageUrl: photoUrl!,
                shape: BoxShape.circle,
              )
            : Container(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                clipBehavior: Clip.antiAlias,
                child: Image.asset("assets/graphics/avatar.png"),
              ),
      ),
    );
  }
}
