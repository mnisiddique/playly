import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:playly/core/app/navigation/named_route.dart';
import 'package:playly/core/presentation/cubit/now_playing_audio/now_playing_audio_cubit.dart';
import 'package:playly/core/presentation/model/audio_model.dart';
import 'package:playly/res/index.dart';

class AudioPlayerRoute extends GoRoute {
  AudioPlayerRoute()
    : super(
        path: NamedRoute.audioPlayer.routePath,
        name: NamedRoute.audioPlayer.routeName,
        builder: (context, state) => AudioPlayerScreen(),
      );
}

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NowPlayingAudioCubit, NowPlayingAudioState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const SizedBox.shrink(),
            nowPlaying: (audio) {
              return AudioPlayerScreenContent(song: audio);
            },
          );
        },
      ),
    );
  }
}

class AudioPlayerScreenContent extends StatelessWidget {
  const AudioPlayerScreenContent({super.key, required this.song});
  final AudioModel song;

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Center(
        child: Text(
          song.audio.title,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(nk00, nkNegative0pt1),
          radius: nk1pt2,
          colors: [ColorGen.kCelestialGlow, ColorGen.kCelestialDeep],
          stops: [0.0, 1.0],
        ),
      ),
      child: child,
    );
  }
}
