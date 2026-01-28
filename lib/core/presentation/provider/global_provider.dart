import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playly/core/app/injector/auto_injector.dart';
import 'package:playly/core/presentation/cubit/songs/songs_cubit.dart';

final List<BlocProvider> globalProviders = [
  BlocProvider<SongsCubit>(create: (ctx) => getIt<SongsCubit>()),
];
