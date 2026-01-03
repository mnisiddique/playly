import 'package:flutter/material.dart';
import 'package:playly/core/app/navigation/app_router.dart';
import 'package:playly/res/index.dart';

class PlaylyApp extends StatelessWidget {
  const PlaylyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: vskAppAnme,
      routerConfig: AppRouter().config,
      debugShowCheckedModeBanner: false,
      // theme: context.appThemeWithClient(state),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.noScaling, boldText: false),
        child: child!,
      ),
    );
  }
}
