import 'package:audio_service/audio_service.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:playly/core/service/audio/audio_handler_service.dart';
import 'package:playly/res/index.dart';

@lazySingleton
class AudioHandlerInitializer {
  AudioHandler? _audioHandler;
  bool _isInitializing = false;

  AudioHandler get audioHandler =>
      _audioHandler ??
      (throw UnsupportedError("Audio handler not initialized"));

  Future<void> init() async {
    if (_isInitializing || _audioHandler != null) return;
    _isInitializing = true;

    try {
      _audioHandler = await IsolatedAudioHandler.lookup(portName: skPortName);
    } catch (e) {
      debugPrint("Audio lookup failed, starting fresh: $e");
    }

    _audioHandler ??= await AudioService.init(
      builder: () => IsolatedAudioHandler(
        AudioHandlerService.fromDependency(),
        portName: skPortName,
      ),
      config: const AudioServiceConfig(
        androidNotificationChannelId: skChannelId,
        androidNotificationChannelName: skChannelName,
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
        // Highly recommended for Android 13+ support:
        androidShowNotificationBadge: true,
      ),
    );
  }
}
