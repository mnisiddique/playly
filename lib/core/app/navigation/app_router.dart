import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playly/features/media_list/presentation/route/meadia_list_route.dart';
import 'package:playly/features/player/presentation/route/media_player_route.dart';


final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class AppRouter {
  final GoRouter _routerConfig;
  GoRouter get config => _routerConfig;

  AppRouter._init(this._routerConfig);

  factory AppRouter() {
    return _appRouter;
  }

  static final AppRouter _appRouter = AppRouter._init(
    GoRouter(
      observers: [routeObserver],

      routes: [
        MediaListRoute(),
        MediaPlayerRoute(),
        
      ],
    ),
  );
}
