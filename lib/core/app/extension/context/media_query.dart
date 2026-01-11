import 'package:flutter/material.dart';

extension MediaQueryExt on BuildContext {
  Size get scrSize => MediaQuery.of(this).size;
}
