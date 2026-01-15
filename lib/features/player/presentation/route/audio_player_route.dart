import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:playly/core/app/extension/context/media_query.dart';
import 'package:playly/core/app/extension/string/casing.dart';
import 'package:playly/core/app/navigation/named_route.dart';
import 'package:playly/core/presentation/cubit/now_playing_audio/now_playing_audio_cubit.dart';
import 'package:playly/core/presentation/model/audio_model.dart';
import 'package:playly/core/presentation/widget/app_background.dart';
import 'package:playly/features/player/presentation/route/playback_control_widget.dart';
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
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: nk00,
        leading: LeadingBackButton(),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: BlocBuilder<NowPlayingAudioCubit, NowPlayingAudioState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => const SizedBox.shrink(),
              nowPlaying: (audio) {
                return AudioPlayerScreenContent(song: audio);
              },
            );
          },
        ),
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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(nk16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizeLabel(song: song),
              Gap(nk04),
              NowPlayingArtWork(song: song),
              Gap(nk16),
              NowPlayingTitle(song: song),
              NowPlayingArtist(song: song),
              Gap(nk16),
              AudioPlayingProgress(song: song),
              DurationWidget(song: song),
              Gap(nk24),
              PlaybackControlWidget()
            ],
          ),
        ),
      ),
    );
  }
}

class NowPlayingArtist extends StatelessWidget {
  const NowPlayingArtist({super.key, required this.song});

  final AudioModel song;

  @override
  Widget build(BuildContext context) {
    return Text(
      song.artistLabel.toTitleCase(),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Colors.white70,
        letterSpacing: nkNegative0pt31,
      ),
    );
  }
}

class NowPlayingTitle extends StatelessWidget {
  const NowPlayingTitle({super.key, required this.song});

  final AudioModel song;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          MediaQuery.of(context).size.width * nk0pt7, // Force a specific width
      height: nk32, // Use a static height for testing
      child: Marquee(
        key: ValueKey(song.audio.title), // Crucial for audio players
        text: song.audio.title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          letterSpacing: nkNegative0pt31,
        ),
        scrollAxis: Axis.horizontal,
        blankSpace: 30.0,
        velocity: 50.0, // Slow it down to see if it starts
        pauseAfterRound: Duration(seconds: 1),
      ),
    );
  }
}

class NowPlayingArtWork extends StatelessWidget {
  final AudioModel song;
  const NowPlayingArtWork({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final awDimension = context.scrSize.width - nk32;
    return QueryArtworkWidget(
      id: song.audio.id,
      type: ArtworkType.AUDIO,
      artworkHeight: awDimension,
      artworkWidth: awDimension,
      artworkBorder: BorderRadius.circular(nk12),
      nullArtworkWidget: Container(
        height: awDimension,
        width: awDimension,
        decoration: BoxDecoration(
          border: Border.all(width: nk02, color: ColorGen.kOrbitStroke),
          borderRadius: BorderRadius.circular(nk12),
        ),
        child: Icon(
          Icons.music_note_rounded,
          color: ColorGen.kCoolGray,
          size: nk200,
        ),
      ),
    );
  }
}

class LeadingBackButton extends StatelessWidget {
  const LeadingBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: RotatedBox(
        quarterTurns: nkInt03,
        child: const Icon(
          Icons.arrow_back_ios_new_outlined,
          color: Colors.white,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}

class SizeLabel extends StatelessWidget {
  const SizeLabel({super.key, required this.song});

  final AudioModel song;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Text(
        song.sizeLabel,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.white,
          letterSpacing: nk00,
        ),
      ),
    );
  }
}
