import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:playly/core/app/navigation/named_route.dart';
import 'package:playly/core/presentation/widget/loading_widget.dart';
import 'package:playly/features/media_list/presentation/route/audio_list_widget.dart';
import 'package:playly/features/media_list/presentation/route/providers.dart';
import 'package:playly/features/media_list/presentation/songs/songs_cubit.dart';
import 'package:playly/res/index.dart';

class MediaListRoute extends GoRoute {
  MediaListRoute()
    : super(
        path: NamedRoute.mediaList.routePath,
        name: NamedRoute.mediaList.routeName,
        builder: (context, state) => MultiBlocProvider(
          providers: mediaCubits,
          child: MeadiaListScreen(),
        ),
      );
}

class MeadiaListScreen extends StatefulWidget {
  const MeadiaListScreen({super.key});

  @override
  State<MeadiaListScreen> createState() => _MeadiaListScreenState();
}

class _MeadiaListScreenState extends State<MeadiaListScreen> {
  @override
  void initState() {
    context.read<SongsCubit>().requestAudioPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorGen.kCloudMist,
      body: SafeArea(
        child: BlocBuilder<SongsCubit, SongsState>(
          builder: (context, state) {
            return state.when(
              initial: () => SizedBox.shrink(),
              loading: () => Center(child: LoadingWidget()),
              loaded: (songs) => AudioListWidget(songs: songs),
              noSong: () => NoAudioWidget(),
              noPermission: (isPermament) =>
                  PermissionDeniedWidget(isPermment: isPermament),
            );
          },
        ),
      ),
    );
  }
}

class PermissionDeniedWidget extends StatelessWidget {
  final bool isPermment;
  const PermissionDeniedWidget({super.key, required this.isPermment});

  @override
  Widget build(BuildContext context) {
    return isPermment
        ? Center(
            child: TextButton(
              onPressed: () => openAppSettings(),
              child: Text("Allow Permission from settings"),
            ),
          )
        : Center(
            child: TextButton(
              onPressed: () =>
                  context.read<SongsCubit>().requestAudioPermission(),
              child: Text("Allow Audio Permission"),
            ),
          );
  }
}

class NoAudioWidget extends StatelessWidget {
  const NoAudioWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("No Audio files"));
  }
}


