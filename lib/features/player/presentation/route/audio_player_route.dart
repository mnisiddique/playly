import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:playly/core/app/navigation/named_route.dart';
import 'package:playly/core/presentation/cubit/now_playing_audio/now_playing_audio_cubit.dart';
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
    return Scaffold(body: AudioPlayerScreenContent());
  }
}

class AudioPlayerScreenContent extends StatelessWidget {
  const AudioPlayerScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingAudioCubit, NowPlayingAudioState>(
      builder: (context, state) {
        final title = state.maybeWhen(
          orElse: () => vskEmpty,
          nowPlaying: (audio) => audio.audio.title,
        );
        final id = state.maybeWhen(
          orElse: () => -1,
          nowPlaying: (audio) => audio.position,
        );
        return Center(child: Text("$title\n$id"));
      },
    );
  }
}
