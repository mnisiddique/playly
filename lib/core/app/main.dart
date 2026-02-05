import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playly/core/app/app.dart';
import 'package:playly/core/app/injector/auto_injector.dart';
import 'package:playly/core/service/audio/audio_handler_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  configureDependencies();
  await getIt<AudioHandlerInitializer>().init();
  runApp(const PlaylyApp());
}
