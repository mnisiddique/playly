import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:playly/core/app/extension/duration/duration_formatter.dart';
import 'package:playly/core/app/injector/auto_injector.dart';
import 'package:playly/core/presentation/widget/neumorphic_icon_button.dart';
import 'package:playly/core/presentation/widget/playback_state_builder.dart';
import 'package:playly/core/service/audio/audio_handler_initializer.dart';
import 'package:playly/core/service/audio/live_playback_update.dart';
import 'package:playly/features/player/presentation/route/play_mode_button.dart';
import 'package:playly/res/index.dart';

class PlaybackControlWidget extends StatelessWidget {
  const PlaybackControlWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ControlRow(),
        VerticalLine(height: nk24),
        PlayerModeButton(),
      ],
    );
  }
}

class ControlRow extends StatelessWidget {
  const ControlRow({super.key});

  @override
  Widget build(BuildContext context) {
    final separatorWidth = nk42;
    final audioHandler = getIt<AudioHandlerInitializer>().audioHandler;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NeumorphicIconButton(
          radius: nk48,
          icon: Icon(Icons.skip_previous_outlined, color: Colors.white),
          onTapCallback: audioHandler.skipToPrevious,
        ),
        HorizontalLine(width: separatorWidth),
        PlayButton(audioHandler: audioHandler),
        HorizontalLine(width: separatorWidth),
        NeumorphicIconButton(
          radius: nk48,
          icon: Icon(Icons.skip_next_outlined, color: Colors.white),
          onTapCallback: audioHandler.skipToNext,
        ),
      ],
    );
  }
}

class PlayButton extends StatelessWidget {
  final AudioHandler audioHandler;
  const PlayButton({super.key, required this.audioHandler});

  @override
  Widget build(BuildContext context) {
    return PlaybackStateBuilder(
      builder: (playbackState) {
        final isPlaying = playbackState == null ? false : playbackState.playing;
        return NeumorphicIconButton(
          radius: nk64,
          icon: Icon(
            isPlaying ? Icons.pause_outlined : Icons.play_arrow_outlined,
            size: nk48,
            color: Colors.white,
          ),
          onTapCallback: isPlaying ? audioHandler.pause : audioHandler.play,
        );
      },
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
  final Duration? totalDuration;
  const DurationWidget({super.key, required this.totalDuration});

  @override
  Widget build(BuildContext context) {
    final audioHandler = getIt<AudioHandlerInitializer>().audioHandler;
    audioHandler.mediaItem;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DurationText(dur: totalDuration),
        DurationBuilder(stream: getIt<LivePlaybackUpdate>().positionStream),
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
        return DurationText(dur: dur);
      },
    );
  }
}

class DurationText extends StatelessWidget {
  const DurationText({super.key, required this.dur});

  final Duration? dur;

  @override
  Widget build(BuildContext context) {
    return Text(
      dur == null ? vskNA : dur!.toMMSS(),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Colors.white70,
        letterSpacing: nkNegative0pt31,
      ),
    );
  }
}

class AudioPlayingProgress extends StatefulWidget {
  final Duration? totalDuration;
  const AudioPlayingProgress({super.key, required this.totalDuration});

  @override
  State<AudioPlayingProgress> createState() => _AudioPlayingProgressState();
}

class _AudioPlayingProgressState extends State<AudioPlayingProgress> {
  double _draggedProgress = nk00;

  @override
  Widget build(BuildContext context) {
    final minHeight = nk04;
    final audioHandler = getIt<AudioHandlerInitializer>().audioHandler;
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
          stream: getIt<LivePlaybackUpdate>().positionStream,
          builder: (context, posSnapshot) {
            final posDur = posSnapshot.data ?? Duration.zero;
            final computedTotal = widget.totalDuration == null
                ? Duration(seconds: nkInt01)
                : widget.totalDuration!;
            return Slider(
              allowedInteraction: SliderInteraction.tapAndSlide,
              value: widget.totalDuration == null
                  ? nk01
                  : posDur.inMilliseconds.toDouble().clamp(
                      nk00,
                      computedTotal.inMilliseconds.toDouble(),
                    ),
              min: nk00,
              max: widget.totalDuration == null
                  ? nk01
                  : computedTotal.inMilliseconds.toDouble(),
              onChanged: widget.totalDuration == null
                  ? null
                  : (value) {
                      // audioHandler.seek(Duration(milliseconds: value.toInt()));
                      _draggedProgress = value;
                    },
              onChangeEnd: widget.totalDuration == null
                  ? null
                  : (value) {
                      final dur = Duration(
                        milliseconds: _draggedProgress.toInt(),
                      );
                      audioHandler.seek(dur);
                    },
            );
          },
        ),
      ),
    );
  }
}
