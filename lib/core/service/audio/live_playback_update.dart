import 'package:injectable/injectable.dart';
import 'package:playly/core/service/audio/audio_handler_initializer.dart';
import 'package:playly/core/service/audio/play_mode_model.dart';
import 'package:playly/res/index.dart';

@Injectable()
class LivePlaybackUpdate {
  final AudioHandlerInitializer _audioHandlerInitializer;

  LivePlaybackUpdate({required AudioHandlerInitializer audioHandlerInitializer})
    : _audioHandlerInitializer = audioHandlerInitializer;

  Stream<Duration> get positionStream {
    return Stream.periodic(const Duration(milliseconds: nkInt300), (_) {
      return _audioHandlerInitializer.audioHandler.playbackState.value.position;
    });
  }
}

@Injectable()
class LivePlayModeUpdate {
  final AudioHandlerInitializer _audioHandlerInitializer;

  LivePlayModeUpdate({required AudioHandlerInitializer audioHandlerInitializer})
    : _audioHandlerInitializer = audioHandlerInitializer;

  Stream<PlayModeModel> get playMode {
    return _audioHandlerInitializer.audioHandler.playbackState.map(
      (playbackState) => PlayModeModel.fromPlaybackState(playbackState),
    );
  }
}
