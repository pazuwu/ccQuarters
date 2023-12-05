import 'dart:math';

import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.title,
  });

  final String title;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: min(MediaQuery.of(context).size.width * 0.1, 40),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    final p0 = size.height * 0.7;
    final p1 = Offset(size.width * 0.4, size.height);
    final p3 = Offset(size.width, size.height / 2);

    path.lineTo(0.0, p0);
    path.quadraticBezierTo(p1.dx, p1.dy, p3.dx, p3.dy);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => oldClipper != this;
}
