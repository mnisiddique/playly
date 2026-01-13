import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playly/core/app/navigation/named_route.dart';

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
    return Scaffold(body: Center(child: Text("data")));
  }
}
