import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:playly/core/app/navigation/named_route.dart';
import 'package:playly/features/media_list/presentation/route/listener.dart';
import 'package:playly/features/media_list/presentation/route/providers.dart';
import 'package:playly/features/media_list/presentation/cubit/songs/songs_cubit.dart';
import 'package:gap/gap.dart';
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
    return AudioListListeners(
      child: Scaffold(
        backgroundColor: ColorGen.kCloudMist,
        body: SafeArea(
          child: PlaceHolderWidget(
            title: vskNoAudioTitle,
            supportingText: vskNoAudioMessage,
            animName: AssetGen.anim.noData,
            dimension: nk202,
          ),
          // child: BlocBuilder<SongsCubit, SongsState>(
          //   builder: (context, state) {
          //     return state.when(
          //       initial: () => SizedBox.shrink(),
          //       loading: () => Center(child: LoadingWidget()),
          //       loaded: (songs) => AudioListWidget(songs: songs),
          //       noSong: () => PlaceHolderWidget(
          //         title: vskNoAudioTitle,
          //         supportingText: vskNoAudioMessage,
          //         animName: AssetGen.anim.noData,
          //       ),
          //       noPermission: (isPermament) =>
          //           PermissionDeniedWidget(isPermment: isPermament),
          //     );
          //   },
          // ),
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

class PlaceHolderWidget extends StatelessWidget {
  final String title;
  final String supportingText;
  final String animName;
  final double dimension;
  const PlaceHolderWidget({
    super.key,
    required this.title,
    required this.supportingText,
    required this.animName,
    required this.dimension,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          animName,
          width: dimension,
          height: dimension,
          fit: BoxFit.cover,
        ),
        Gap(nk16),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: ColorGen.kCarbonBlue,
            letterSpacing: nk00,
          ),
        ),
        Gap(nk08),
        Text(
          supportingText,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ColorGen.kCarbonBlue,
            letterSpacing: nk0pt25,
          ),
        ),
      ],
    );
  }
}
