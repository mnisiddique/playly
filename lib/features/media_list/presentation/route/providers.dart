import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playly/core/app/injector/auto_injector.dart';
import 'package:playly/features/media_list/presentation/cubit/audio_search/audio_search_cubit.dart';
import 'package:playly/features/media_list/presentation/cubit/songs/songs_cubit.dart';

final List<BlocProvider> mediaCubits = [
  BlocProvider<SongsCubit>(create: (ctx) => getIt<SongsCubit>()),
  BlocProvider<AudioSearchCubit>(create: (ctx) => getIt<AudioSearchCubit>()),
];
