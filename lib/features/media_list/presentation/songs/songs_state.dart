part of 'songs_cubit.dart';

@freezed
abstract class SongsState with _$SongsState {
  const factory SongsState.initial() = _Initial;
  const factory SongsState.loading() = _Loading;
  const factory SongsState.loaded({required List<AudioMediaEntity> songs}) = _Loaded;
  const factory SongsState.noSong() = _NoSong;
  const factory SongsState.noPermission() = _NoPermission;
}
