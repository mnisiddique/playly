

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playly/core/app/injector/auto_injector.dart';
import 'package:playly/core/presentation/cubit/now_playing_audio/now_playing_audio_cubit.dart';
import 'package:playly/core/presentation/cubit/songs/songs_cubit.dart';
import 'package:playly/features/player/presentation/cubit/playback/plaback_cubit.dart';

final List<BlocProvider> globalProviders = [
  BlocProvider<SongsCubit>(create: (ctx) => getIt<SongsCubit>()),
  BlocProvider<NowPlayingAudioCubit>(create: (ctx) => getIt<NowPlayingAudioCubit>()),
  BlocProvider<PlayBackCubit>(create: (ctx) => getIt<PlayBackCubit>()),
];