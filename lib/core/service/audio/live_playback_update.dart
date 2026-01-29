import 'package:injectable/injectable.dart';
import 'package:playly/core/service/audio/audio_handler_initializer.dart';
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
