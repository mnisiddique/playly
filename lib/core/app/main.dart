import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playly/core/app/app.dart';
import 'package:playly/core/app/injector/auto_injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  configureDependencies();
  runApp(const PlaylyApp());
}
