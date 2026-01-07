part of 'audio_search_cubit.dart';

@freezed
abstract class AudioSearchState with _$AudioSearchState {
  const factory AudioSearchState.closed() = _Closed;
  const factory AudioSearchState.opened() = _Opened;
  const factory AudioSearchState.searching(String query) = _Searching;
}
