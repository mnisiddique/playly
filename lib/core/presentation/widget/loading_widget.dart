import 'package:flutter/material.dart';
import 'package:playly/core/app/extension/app_theme.dart';
import 'package:playly/res/index.dart';

class LoadingWidget extends StatelessWidget {
  final double size;
  final double trackGap;
  final Color? color;
  final Color trackColor;
  const LoadingWidget({
    super.key,
    this.size = nk48,
    this.trackGap = nk04,
    this.color,
    this.trackColor = ColorGen.kLavendarMist,
  });

  @override
  Widget build(BuildContext context) {
    return ProgressIndicatorTheme(
      data: ProgressIndicatorThemeData(
        color: color ?? context.appPrimaryColor,
        // circularTrackColor: trackColor,
        trackGap: trackGap,
        strokeWidth: 4,
        strokeCap: StrokeCap.round
        // Currently there is no alternative to achieve M3 impact without using this deprecated member.
        // This is why we are keeping it.
        // ignore: deprecated_member_use
      ),
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(),
      ),
    );
  }
}