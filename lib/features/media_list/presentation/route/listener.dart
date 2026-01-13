import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playly/features/media_list/presentation/cubit/audio_search/audio_search_cubit.dart';
import 'package:playly/core/presentation/cubit/songs/songs_cubit.dart';
import 'package:playly/res/index.dart';

class AudioListListeners extends MultiBlocListener {
  AudioListListeners({super.key, required super.child})
    : super(listeners: [AudioSearchListener()]);
}

class AudioSearchListener
    extends BlocListener<AudioSearchCubit, AudioSearchState> {
  AudioSearchListener({super.key})
    : super(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () => null,
            closed: () => context.read<SongsCubit>().filterSongs(vskEmpty),
            searching: (query) {
              context.read<SongsCubit>().filterSongs(query);
            },
          );
        },
      );
}
