part of 'now_playing_audio_cubit.dart';

@freezed
abstract class NowPlayingAudioState with _$NowPlayingAudioState {
  const factory NowPlayingAudioState.initial() = _Initial;
  const factory NowPlayingAudioState.nowPlaying({required AudioModel audio}) =
      _NowPlaying;
}
