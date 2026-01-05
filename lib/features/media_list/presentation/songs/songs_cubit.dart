import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:playly/features/media_list/domain/entity/audio_media.dart';
import 'package:playly/features/media_list/domain/usecase/get_songs_uc.dart';

part 'songs_state.dart';
part 'songs_cubit.freezed.dart';

@Injectable()
class SongsCubit extends Cubit<SongsState> {
  final GetSongsUc _getSongsUc;
  SongsCubit({required GetSongsUc getSongsUc})
    : _getSongsUc = getSongsUc,
      super(SongsState.initial());

  void getSongs() async {
    emit(SongsState.loading());
    final songs = await _getSongsUc();
    if (songs.isEmpty) {
      emit(SongsState.noSong());
    } else {
      emit(SongsState.loaded(songs: songs));
    }
  }
}
