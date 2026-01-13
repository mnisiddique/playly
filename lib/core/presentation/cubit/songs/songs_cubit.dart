import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:playly/core/app/extension/list.dart';
import 'package:playly/core/presentation/model/audio_model.dart';
import 'package:playly/core/service/permission_service.dart';
import 'package:playly/features/media_list/domain/usecase/get_songs_uc.dart';

part 'songs_state.dart';
part 'songs_cubit.freezed.dart';

@Injectable()
class SongsCubit extends Cubit<SongsState> {
  final GetSongsUc _getSongsUc;
  final RequestPermission _requestAudioPermission;

  List<AudioModel> _allSongs = [];

  SongsCubit({
    required GetSongsUc getSongsUc,

    @Named.from(RequestAudioPermission)
    required RequestPermission requestAudioPermission,
  }) : _getSongsUc = getSongsUc,
       _requestAudioPermission = requestAudioPermission,
       super(SongsState.initial());

  void getSongs() async {
    final songs = await _getSongsUc();
    if (songs.isEmpty) {
      emit(SongsState.noSong());
    } else {
      _allSongs = songs.mapIndexed(
        (index, song) => AudioModel(audio: song, position: index),
      );
      emit(SongsState.loaded(songs: _allSongs));
    }
  }

  void requestAudioPermission() async {
    emit(SongsState.loading());
    final status = await _requestAudioPermission();
    switch (status) {
      case AppPermissionStatus.granted:
        getSongs();
        break;
      case AppPermissionStatus.denied:
        emit(SongsState.noPermission(false));
        break;
      case AppPermissionStatus.permanentlyDenied:
        emit(SongsState.noPermission(true));
        break;
    }
  }

  void filterSongs(String query) {
    final filteredSongs = _allSongs
        .where(
          (song) =>
              song.audio.title.toLowerCase().contains(query.toLowerCase()) ||
              song.audio.artist.toLowerCase().contains(query.toLowerCase()) ||
              song.audio.album.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    emit(SongsState.loaded(songs: filteredSongs));
  }
}
