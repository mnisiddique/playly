import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:playly/res/index.dart';

@module
abstract class RegisterModule {
  OnAudioQuery get audioQuery => OnAudioQuery();

  AudioPlayer get audioPlayer => AudioPlayer();

  DeviceInfoPlugin get deviceInfo => DeviceInfoPlugin();

  @Named(skStoragePermission)
  Permission get storage => Permission.storage;

  @Named(skAudioPermission)
  Permission get audio => Permission.audio;

  @Named(skIosMediaLibraryPermission)
  Permission get iosMediaLibrary => Permission.mediaLibrary;
}
