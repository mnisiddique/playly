import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:playly/core/app/injector/auto_injector.dart';
import 'package:playly/core/service/audio/audio_handler_initializer.dart';

class PlaybackStateBuilder extends StatelessWidget {
  final Widget Function(PlaybackState?) builder;
  const PlaybackStateBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: getIt<AudioHandlerInitializer>().audioHandler.playbackState,
      builder: (ctx, snapshot) {
        return builder(snapshot.data);
      },
    );
  }
}
