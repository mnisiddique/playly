import 'package:flutter/material.dart';
import 'package:playly/res/index.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(nk00, nkNegative0pt1),
          radius: nk1pt2,
          colors: [ColorGen.kCelestialGlow, ColorGen.kCelestialDeep],
          stops: [nk00, nk01],
        ),
      ),
      child: child,
    );
  }
}