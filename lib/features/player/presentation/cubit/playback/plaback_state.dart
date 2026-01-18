part of 'plaback_cubit.dart';

@freezed
class PlayBackState with _$PlayBackState {
  const factory PlayBackState.initial() = _Initial;
  const factory PlayBackState.audioInitialized() = _AudioInitialized;
  const factory PlayBackState.playing() = _Playing;
  const factory PlayBackState.paused() = _Paused;
  const factory PlayBackState.done() = _Done;

  const factory PlayBackState.error({required Object error}) = _Error;
}
