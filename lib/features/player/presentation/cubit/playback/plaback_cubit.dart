import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';

part 'plaback_state.dart';
part 'plaback_cubit.freezed.dart';

@Injectable()
class PlabackCubit extends Cubit<PlabackState> {
  final AudioPlayer _audioPlayer;
  PlabackCubit({required AudioPlayer audioPlayer})
    : _audioPlayer = audioPlayer,
      super(PlabackState.initial());

  void play() async {
    await _audioPlayer.play();
    _audioPlayer.positionStream.listen(
      (position) {
        // You can emit position updates here if needed
      },
      onDone: () {
        emit(PlabackState.stopped());
      },
    );
    emit(PlabackState.playing());
  }

  void pause() async {
    await _audioPlayer.pause();
    emit(PlabackState.paused());
  }

  void stop() async {
    await _audioPlayer.stop();
    emit(PlabackState.stopped());
  }

  void next() {
    _audioPlayer.stop();
  }
}
