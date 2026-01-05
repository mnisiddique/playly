import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playly/res/index.dart';

extension AppTheme on BuildContext {
  ThemeData get appTheme {
    return  ThemeData(
      dialogTheme: DialogThemeData(
        backgroundColor: ColorGen.kAlertBackground,
        actionsPadding: EdgeInsets.only(right: nk16, bottom: nk16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(nk28),
        ),
        titleTextStyle: Theme.of(this).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w400,
              color: ColorGen.kSecondaryDarkGrey,
            ),
        contentTextStyle: Theme.of(this).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
              color: ColorGen.kSecondaryGrey,
            ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorGen.kJadeGreen,
        primary: ColorGen.kJadeGreen,
      ),
      fontFamily: GoogleFonts.roboto().fontFamily,
      useMaterial3: true,
    );
  }

  Color get appPrimaryColor {
    return Theme.of(this).colorScheme.primary;
  }
}
