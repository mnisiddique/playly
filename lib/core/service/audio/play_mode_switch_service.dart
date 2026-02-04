import 'package:injectable/injectable.dart';
import 'package:playly/core/app/injector/auto_injector.dart';
import 'package:playly/core/service/audio/audio_handler_initializer.dart';
import 'package:playly/core/service/audio/play_mode_model.dart';
import 'package:playly/core/service/cache/play_mode_cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton()
class PlayModeSwitchService {
  final PlayModeCacheService _cacheService;
  final AudioHandlerInitializer _initializer;

  bool _isSwitching = false;

  PlayModeSwitchService({
    required PlayModeCacheService cacheService,
    required AudioHandlerInitializer initializer,
  }) : _cacheService = cacheService,
       _initializer = initializer;

  @factoryMethod
  factory PlayModeSwitchService.fromDependency() {
    return PlayModeSwitchService(
      cacheService: PlayModeCacheServiceImpl(pref: SharedPreferencesAsync()),
      initializer: getIt<AudioHandlerInitializer>(),
    );
  }

  PlayModeModel getNextMode(PlayModeModel? currentMode) {
    final nonNullcurrentModel =
        currentMode ?? PlayModeModel(playMode: PlayMode.none);

    return switch (nonNullcurrentModel.playMode) {
      PlayMode.none => PlayModeModel(playMode: PlayMode.repeatAll),
      PlayMode.repeatAll => PlayModeModel(playMode: PlayMode.repeatCurrent),
      PlayMode.repeatCurrent => PlayModeModel(playMode: PlayMode.shuffle),
      PlayMode.shuffle => PlayModeModel(playMode: PlayMode.none),
    };
  }

  Future<void> switchModeFrom(PlayModeModel? currentMode) async {
    if (_isSwitching) {
      return;
    }

    _isSwitching = true;
    final handler = _initializer.audioHandler;

    final nextMode = getNextMode(currentMode);
    List<Future<void>> futures = [
      handler.setRepeatMode(nextMode.toRepeatMode()),
      handler.setShuffleMode(nextMode.toShuffleMode()),
      _cacheService.cache(nextMode.playMode),
    ];
    await Future.wait(futures);
    _isSwitching = false;
  }
}
