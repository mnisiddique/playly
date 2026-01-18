import 'package:audio_session/audio_session.dart';
import 'package:injectable/injectable.dart';

abstract class AudioSessionService {
  Future<void> configAudioSession();
}

@LazySingleton(as: AudioSessionService)
class AudioSessionServiceImpl implements AudioSessionService {
  bool _configDone = false;

  AudioSessionServiceImpl();
  @override
  Future<void> configAudioSession() async {
    if (!_configDone) {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
      _configDone = true;
    }
  }
}
