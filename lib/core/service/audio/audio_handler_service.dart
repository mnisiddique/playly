import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:playly/core/presentation/provider/audio_model_list_provider.dart';

class AudioHandlerService extends BaseAudioHandler {
  final AudioPlayer _audioPlayer;
  final AudioModelListProvider _audioListProvider;

  AudioHandlerService({
    required AudioPlayer audioPlayer,
    required AudioModelListProvider audioListProvider,
  }) : _audioListProvider = audioListProvider,
       _audioPlayer = audioPlayer;

  @override
  Future<void> play() {
    return _audioPlayer.play();
  }

  @override
  Future<void> pause() {
    return _audioPlayer.pause();
  }
}
