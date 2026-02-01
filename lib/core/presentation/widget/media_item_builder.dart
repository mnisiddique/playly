
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:playly/core/app/injector/auto_injector.dart';
import 'package:playly/core/service/audio/audio_handler_initializer.dart';
import 'package:playly/res/index.dart';

class MediaItemBuilder extends StatelessWidget {
  final Widget Function(MediaItem) onData;
  final Widget Function(Object) onError;
  const MediaItemBuilder({
    super.key,
    required this.onData,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: getIt<AudioHandlerInitializer>().audioHandler.mediaItem,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return onData(snapshot.data!);
        } else if (snapshot.hasError) {
          return onError(snapshot.error!);
        }
        return onError(vskFailedToLoadAdio);
      },
    );
  }
}
