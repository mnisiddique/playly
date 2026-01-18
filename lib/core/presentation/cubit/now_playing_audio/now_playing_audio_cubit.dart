import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:playly/core/presentation/model/audio_model.dart';
import 'package:playly/core/presentation/provider/audio_model_list_provider.dart';

part 'now_playing_audio_state.dart';
part 'now_playing_audio_cubit.freezed.dart';

@Injectable()
class NowPlayingAudioCubit extends Cubit<NowPlayingAudioState> {
  final AudioModelListProvider _audioModelListProvider;
  NowPlayingAudioCubit({required AudioModelListProvider audioModelListProvider})
    : _audioModelListProvider = audioModelListProvider,
      super(NowPlayingAudioState.initial());

  void setNowPlayingAudio(AudioModel audio) {
    emit(NowPlayingAudioState.nowPlaying(audio: audio));
  }

  void nextAudio() {
    final currPos = currentPosition();
    final audioList = _audioModelListProvider.getAudioModels();
    final nextPos = normalize(currPos + 1, audioList.length);
    if (currPos >= 0) {
      setNowPlayingAudio(audioList[nextPos]);
    }
  }

  void previousAudio() {
    final currPos = currentPosition();
    final audioList = _audioModelListProvider.getAudioModels();
    final prevPos = normalize(currPos - 1, audioList.length);
    if (currPos >= 0) {
      setNowPlayingAudio(audioList[prevPos]);
    }
  }

  int currentPosition() {
    return state.maybeWhen(
      nowPlaying: (audio) => audio.position,
      orElse: () => -1,
    );
  }

  bool isNewPositionValid(int newPosition, int length) {
    return newPosition >= 0 && newPosition < length;
  }

  int normalize(int newPosition, int length) {
    if (newPosition >= 0 && newPosition < length) {
      return newPosition;
    } else if (newPosition < 0) {
      return length - 1;
    } else if (newPosition >= length) {
      return 0;
    }
    throw Exception('Invalid position');
  }
}
