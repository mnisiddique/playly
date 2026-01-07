import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playly/res/index.dart';

extension AppTheme on BuildContext {
  ThemeData get appTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorGen.kElectricIndigo,
        surface: ColorGen.kCloudMist, // Your background spec
        onSurface: ColorGen.kCarbonBlue, // Your title spec
        onSurfaceVariant: ColorGen.kCharcolBlue, // Your subtitle spec
        brightness: Brightness.light,
      ),
      fontFamily: GoogleFonts.roboto().fontFamily,
      useMaterial3: true,
    );
  }

  Color get appPrimaryColor {
    return Theme.of(this).colorScheme.primary;
  }
}
