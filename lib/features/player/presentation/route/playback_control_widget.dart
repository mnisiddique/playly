import 'package:flutter/material.dart';
import 'package:playly/core/presentation/model/audio_model.dart';
import 'package:playly/core/presentation/widget/neumorphic_icon_button.dart';
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
          onTapCallback: () {},
        ),
        HorizontalLine(width: separatorWidth),
        NeumorphicIconButton(
          radius: nk64,
          icon: Icon(Icons.play_arrow_outlined, size: nk48, color: Colors.white),
          onTapCallback: () {},
        ),
        HorizontalLine(width: separatorWidth),
        NeumorphicIconButton(
          radius: nk48,
          icon: Icon(Icons.skip_next_outlined, color: Colors.white),
          onTapCallback: () {},
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

