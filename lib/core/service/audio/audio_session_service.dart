import 'package:audio_session/audio_session.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:playly/res/index.dart';

abstract class AudioSessionService {
  Future<void> configAudioSession(AudioPlayer player);
}

@LazySingleton(as: AudioSessionService)
class AudioSessionServiceImpl implements AudioSessionService {
  static bool _isConfiguring = false;
  static bool _configDone = false;
  static bool _interrupted = false;

  @override
  Future<void> configAudioSession(AudioPlayer player) async {
    if (_configDone || _isConfiguring) return;

    _isConfiguring = true;
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
      handleInterruption(session, player);
      _configDone = true;
    } finally {
      _isConfiguring = false;
    }
  }

  void handleInterruption(AudioSession session, AudioPlayer player) {
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            // The OS wants us to stop
            _interrupted = player.playing;
            if (_interrupted) {
              player.pause();
            }
            break;
          case AudioInterruptionType.duck:
            // The OS wants us to be quiet (e.g., GPS speaking)
            player.setVolume(nk0pt1);
            break;
        }
      } else {
        // The interruption ended
        switch (event.type) {
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            if (_interrupted) {
              player.play();
            }
            break;
          case AudioInterruptionType.duck:
            player.setVolume(nk01);
            break;
        }
      }
    });
  }
}
