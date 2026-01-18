import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playly/core/presentation/cubit/now_playing_audio/now_playing_audio_cubit.dart';
import 'package:playly/features/player/presentation/cubit/playback/plaback_cubit.dart';

class AudioPlaybackListeners extends MultiBlocListener {
  AudioPlaybackListeners({super.key, required super.child})
    : super(listeners: [NowPlayingAudioListener()]);
}

class NowPlayingAudioListener
    extends BlocListener<NowPlayingAudioCubit, NowPlayingAudioState> {
  NowPlayingAudioListener({super.key})
    : super(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () => null,
            nowPlaying: (audio) {
              context.read<PlayBackCubit>().initAudio(audio);
            },
          );
        },
      );
}

class PlayBackAudioListener extends BlocListener<PlayBackCubit, PlayBackState> {
  PlayBackAudioListener({super.key})
    : super(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () => null,
            done: () {
              context.read<NowPlayingAudioCubit>().nextAudio();
            },
            audioInitialized: () {
              context.read<PlayBackCubit>().play();
            },
          );
        },
      );
}
