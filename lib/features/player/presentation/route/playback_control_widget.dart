import 'package:flutter/material.dart';
import 'package:playly/core/presentation/model/audio_model.dart';
import 'package:playly/core/presentation/widget/neumorphic_icon_button.dart';
import 'package:playly/res/index.dart';

class DurationWidget extends StatelessWidget {
  final AudioModel song;
  const DurationWidget({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          song.durationLabel,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
            letterSpacing: nkNegative0pt31,
          ),
        ),
        Text(
          song.durationLabel, //TODO: Change to remaining duration
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
            letterSpacing: nkNegative0pt31,
          ),
        ),
      ],
    );
  }
}

class AudioPlayingProgress extends StatelessWidget {
  const AudioPlayingProgress({super.key, required this.song});

  final AudioModel song;

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
        child: Slider(
          allowedInteraction: SliderInteraction.tapAndSlide,
          value: 40,
          min: 0,
          max: 100,
          onChanged: (value) {
            // setState(() => _currentValue = value);
          },
        ),
      ),
    );
  }
}

class PlaybackControlWidget extends StatelessWidget {
  const PlaybackControlWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [ControlRow()]);
  }
}

class ControlRow extends StatelessWidget {
  const ControlRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      NeumorphicIconButton(icon: icon),
    ]);
  }
}
