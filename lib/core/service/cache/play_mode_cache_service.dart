import 'package:playly/core/service/audio/play_mode_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PlayMode { repeatAll, none, repeatCurrent, shuffle }

const String _keyPlayMode = "playMode";

abstract class PlayModeCacheService {
  Future<void> cache(PlayMode playMode);
  Future<PlayModeModel> getCache();
}

//No getIt reg cause it will be used inside separate isolate
class PlayModeCacheServiceImpl implements PlayModeCacheService {
  final SharedPreferencesAsync _pref;

  PlayModeCacheServiceImpl({required SharedPreferencesAsync pref})
    : _pref = pref;

  @override
  Future<void> cache(PlayMode playMode) async {
    _pref.setInt(_keyPlayMode, playMode.index);
  }

  @override
  Future<PlayModeModel> getCache() async {
    int index = await _pref.getInt(_keyPlayMode) ?? 0;
    return PlayModeModel(playMode: PlayMode.values[index]);
  }
}
