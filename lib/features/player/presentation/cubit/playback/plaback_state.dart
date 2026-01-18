part of 'plaback_cubit.dart';

@freezed
class PlabackState with _$PlabackState {
  const factory PlabackState.initial() = _Initial;
  const factory PlabackState.playing() = _Playing;
  const factory PlabackState.paused() = _Paused;
  const factory PlabackState.stopped() = _Stopped;
}
