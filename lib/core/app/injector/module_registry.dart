
import 'package:injectable/injectable.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';


@module
abstract class RegisterModule {
  OnAudioQuery get audioQuery => OnAudioQuery();
}
