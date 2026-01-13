import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:playly/core/app/extension/app_theme.dart';
import 'package:playly/core/app/navigation/named_route.dart';
import 'package:playly/core/presentation/widget/loading_widget.dart';
import 'package:playly/features/media_list/presentation/route/audio_list_widget.dart';
import 'package:playly/features/media_list/presentation/route/listener.dart';
import 'package:playly/features/media_list/presentation/route/providers.dart';
import 'package:playly/core/presentation/cubit/songs/songs_cubit.dart';
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
      ),
    );
  }
}

class PermissionDeniedWidget extends StatelessWidget {
  final bool isPermment;
  const PermissionDeniedWidget({super.key, required this.isPermment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(nk16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            AssetGen.anim.noMusicAccess,
            width: nk202,
            height: nk202,
            fit: BoxFit.cover,
          ),
          Gap(nk16),
          Text(
            vskPermissionDenialTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: ColorGen.kCarbonBlue,
              letterSpacing: nk00,
            ),
          ),
          Gap(nk08),
          Text(
            isPermment
                ? vskPermissionPermamentlyDenialMessage
                : vskPermissionDenialMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColorGen.kCarbonBlue,
              letterSpacing: nk0pt25,
            ),
          ),
          Gap(nk24),
          MaterialButton(
            color: context.appPrimaryColor,
            height: nk48,
            elevation: nk00,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(nk24),
            ),
            onPressed: () {
              if (isPermment) {
                openAppSettings();
              } else {
                context.read<SongsCubit>().requestAudioPermission();
              }
            },
            child: Text(
              isPermment ? vskOpenSettings : vskGrantPermission,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                // color: ColorGen.kCarbonBlue,
                letterSpacing: nk0pt30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoAudioWidget extends StatelessWidget {
  const NoAudioWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = nk202;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          AssetGen.anim.noData,
          width: dimension,
          height: dimension,
          fit: BoxFit.cover,
        ),
        Gap(nk16),
        Text(
          vskNoAudioTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: ColorGen.kCarbonBlue,
            letterSpacing: nk00,
          ),
        ),
        Gap(nk08),
        Text(
          vskNoAudioMessage,
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
