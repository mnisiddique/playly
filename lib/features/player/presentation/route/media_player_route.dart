import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playly/core/app/navigation/named_route.dart';

class MediaPlayerRoute extends GoRoute {
  MediaPlayerRoute()
    : super(
        path: NamedRoute.mediaPlayer.routePath,
        name: NamedRoute.mediaPlayer.routeName,
        builder: (context, state) => MediaPlayerScreen(),
      );
}

class MediaPlayerScreen extends StatelessWidget {
  const MediaPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("data")));
  }
}
