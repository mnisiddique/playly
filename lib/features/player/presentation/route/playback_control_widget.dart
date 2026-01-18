import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:playly/core/app/extension/duration/duration_formatter.dart';
import 'package:playly/core/app/injector/auto_injector.dart';
import 'package:playly/core/presentation/cubit/now_playing_audio/now_playing_audio_cubit.dart';
import 'package:playly/core/presentation/model/audio_model.dart';
import 'package:playly/core/presentation/widget/neumorphic_icon_button.dart';
import 'package:playly/features/player/presentation/cubit/playback/plaback_cubit.dart';
import 'package:playly/res/index.dart';

class PlaybackControlWidget extends StatelessWidget {
  const PlaybackControlWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ControlRow(),
        VerticalLine(height: nk24),
        NeumorphicIconButton(
          radius: nk24,
          gap: nk08,
          icon: Icon(Icons.shuffle_outlined, color: Colors.white),
          onTapCallback: () {},
        ),
      ],
    );
  }
}

class ControlRow extends StatelessWidget {
  const ControlRow({super.key});

  @override
  Widget build(BuildContext context) {
    final separatorWidth = nk42;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NeumorphicIconButton(
          radius: nk48,
          icon: Icon(Icons.skip_previous_outlined, color: Colors.white),
          onTapCallback: context.read<NowPlayingAudioCubit>().previousAudio,
        ),
        HorizontalLine(width: separatorWidth),
        NeumorphicIconButton(
          radius: nk64,
          icon: Icon(
            Icons.play_arrow_outlined,
            size: nk48,
            color: Colors.white,
          ),
          onTapCallback: () {
            context.read<PlayBackCubit>().play();
          },
        ),
        HorizontalLine(width: separatorWidth),
        NeumorphicIconButton(
          radius: nk48,
          icon: Icon(Icons.skip_next_outlined, color: Colors.white),
          onTapCallback: context.read<NowPlayingAudioCubit>().nextAudio,
        ),
      ],
    );
  }
}

class HorizontalLine extends StatelessWidget {
  final double width;
  const HorizontalLine({super.key, this.width = nk24});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: nk1pt57,
      color: ColorGen.kOrbitStroke,
    );
  }
}

class VerticalLine extends StatelessWidget {
  final double height;
  const VerticalLine({super.key, this.height = nk24});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: nk1pt57,
      height: height,
      color: ColorGen.kOrbitStroke,
    );
  }
}

class DurationWidget extends StatelessWidget {
  final AudioModel song;
  const DurationWidget({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final player = getIt<AudioPlayer>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DurationBuilder(stream: player.durationStream),
        DurationBuilder(stream: player.positionStream),
      ],
    );
  }
}

class DurationBuilder extends StatelessWidget {
  const DurationBuilder({super.key, required this.stream});

  final Stream<Duration?> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration?>(
      stream: stream,
      builder: (context, snapshot) {
        final dur = snapshot.data ?? Duration.zero;
        return Text(
          dur.toMMSS(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
            letterSpacing: nkNegative0pt31,
          ),
        );
      },
    );
  }
}

class AudioPlayingProgress extends StatefulWidget {
  const AudioPlayingProgress({super.key});

  @override
  State<AudioPlayingProgress> createState() => _AudioPlayingProgressState();
}

class _AudioPlayingProgressState extends State<AudioPlayingProgress> {
  late final AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = getIt<AudioPlayer>();
    final pbCubit = context.read<PlayBackCubit>();
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        pbCubit.setPlayingDone();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final minHeight = nk04;

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: SliderComponentShape.noThumb,
        trackHeight: minHeight,
        overlayShape: SliderComponentShape.noOverlay,
        activeTrackColor: ColorGen.kActiveWhite,
        inactiveTrackColor: ColorGen.kOrbitStroke,
        trackGap: nk02,
        year2023: false,
      ),
      child: SizedBox(
        height: nk24,
        child: StreamBuilder<Duration?>(
          stream: _player.durationStream,
          builder: (context, durSnapshot) {
            final totalDur = durSnapshot.data ?? Duration.zero;
            return StreamBuilder<Duration?>(
              stream: _player.positionStream,
              builder: (context, posSnapshot) {
                final posDur = posSnapshot.data ?? Duration.zero;
                return Slider(
                  allowedInteraction: SliderInteraction.tapAndSlide,
                  value: posDur.inMilliseconds.toDouble(),
                  min: nk00,
                  max: totalDur.inMilliseconds.toDouble(),
                  onChanged: (value) {
                    context.read<PlayBackCubit>().seekTo(value);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
