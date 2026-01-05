import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playly/core/app/navigation/named_route.dart';

class MediaListRoute extends GoRoute {
  MediaListRoute()
    : super(
        path: NamedRoute.mediaList.routePath,
        name: NamedRoute.mediaList.routeName,
        builder: (context, state) => MeadiaListScreen(),
      );
}

class MeadiaListScreen extends StatelessWidget {
  const MeadiaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("data")));
  }
}


// TODO: Define and  implement audio artwork repo
// TODO: Add necessary permission
// TODO: Decide next todo

