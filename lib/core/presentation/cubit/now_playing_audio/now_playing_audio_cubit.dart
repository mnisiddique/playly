import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:playly/core/presentation/model/now_playing_audio.dart';
import 'package:playly/features/media_list/domain/entity/audio_media.dart';

part 'now_playing_audio_state.dart';
part 'now_playing_audio_cubit.freezed.dart';

@Injectable()
class NowPlayingAudioCubit extends Cubit<NowPlayingAudioState> {
  NowPlayingAudioCubit() : super(NowPlayingAudioState.initial());

  void setNowPlayingAudio({required AudioEntity audio, required int position}) {
    emit(
      NowPlayingAudioState.nowPlaying(
        audio: AudioModel(audio: audio, position: position),
      ),
    );
  }
}
