import 'package:flutter/material.dart';
import 'package:playly/res/index.dart';

class NeumorphicIconButton extends StatelessWidget {
  final double radius;
  final double gap;
  final VoidCallback? onTapCallback;
  final Widget icon;
  const NeumorphicIconButton({
    super.key,
    this.radius = nk60,
    this.gap = nk10,
    this.onTapCallback,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapCallback,
      child: Container(
        height: radius + gap,
        width: radius + gap,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ColorGen.kOrbitStroke, width: nk01),
        ),
        child: Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
            color:
                ColorGen.kCelestialDeep, // Match this to your background color
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorGen.kCelestialGlow, // Slightly lighter than background
                ColorGen.kCelestialDeep, // Slightly darker than background
              ],
            ),
            boxShadow: [
              // 1. Dark Shadow (Bottom Right)
              BoxShadow(
                color: ColorGen.kCelestialGlow.withValues(alpha: nk0pt5),
                offset: Offset(nk04, nk04),
                blurRadius: nk10,
                spreadRadius: nk01,
              ),
              // 2. Light Highlight (Top Left)
              BoxShadow(
                color: ColorGen.kCelestialGlow.withValues(alpha: nk0pt1),
                offset: Offset(nkNegative04, nkNegative04),
                blurRadius: nk10,
                spreadRadius: nk01,
              ),
            ],
          ),
          child: icon,
        ),
      ),
    );
  }
}