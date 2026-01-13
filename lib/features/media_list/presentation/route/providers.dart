import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playly/core/app/injector/auto_injector.dart';
import 'package:playly/features/media_list/presentation/cubit/audio_search/audio_search_cubit.dart';

final List<BlocProvider> mediaCubits = [
  BlocProvider<AudioSearchCubit>(create: (ctx) => getIt<AudioSearchCubit>()),
];
