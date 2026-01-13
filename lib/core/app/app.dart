import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playly/core/app/extension/app_theme.dart';
import 'package:playly/core/app/navigation/app_router.dart';
import 'package:playly/core/presentation/global_provider.dart';
import 'package:playly/res/index.dart';

class PlaylyApp extends StatelessWidget {
  const PlaylyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: globalProviders,
      child: MaterialApp.router(
        title: vskAppAnme,
        routerConfig: AppRouter().config,
        debugShowCheckedModeBanner: false,
        theme: context.appTheme,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling, boldText: false),
          child: child!,
        ),
      ),
    );
  }
}
