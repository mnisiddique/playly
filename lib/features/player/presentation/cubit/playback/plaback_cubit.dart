
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:playly/core/presentation/model/audio_model.dart';
import 'package:playly/core/presentation/provider/audio_model_list_provider.dart';
import 'package:playly/core/service/audio_session_service.dart';

part 'plaback_state.dart';
part 'plaback_cubit.freezed.dart';

@Injectable()
class PlayBackCubit extends Cubit<PlayBackState> {
  final AudioPlayer _audioPlayer;
  final AudioSessionService _audioSessionService;
  PlayBackCubit({
    required AudioPlayer audioPlayer,
    required AudioModelListProvider audioModelListProvider,
    required AudioSessionService audioSessionService,
  }) : _audioPlayer = audioPlayer,
       _audioSessionService = audioSessionService,
       super(PlayBackState.initial());

  void initAudio(AudioModel audio) async {
    try {
      await _audioSessionService.configAudioSession();
      await _audioPlayer.stop();
      await _audioPlayer.setAudioSource(AudioSource.uri(audio.audio.uri!));
      emit(PlayBackState.audioInitialized());
    } on PlayerInterruptedException catch (e) {
      emit(PlayBackState.error(error: e));
    } on PlayerException catch (e) {
      emit(PlayBackState.error(error: e));
    } catch (e) {
      emit(PlayBackState.error(error: e));
    }
  }

  void play() async {
    await _audioPlayer.play();
    emit(PlayBackState.playing());
  }

  void setPlayingDone() {
    emit(PlayBackState.done());
  }

  void pause() async {
    await _audioPlayer.pause();
    emit(PlayBackState.paused());
  }

  void seekTo(double pos) {
    final dur = Duration(milliseconds: pos.toInt());
    _audioPlayer.seek(dur);
  }
}
