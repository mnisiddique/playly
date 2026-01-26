import 'package:shared_preferences/shared_preferences.dart';

enum AppRepeatMode { all, none, current }

const String _keyRepeatMode = "repeatMode";

abstract class RepeatModeCacheService {
  void cache(AppRepeatMode repeatMode);
  Future<AppRepeatMode> getCache();
}

//No getIt reg cause it will be used inside separate isolate
class RepeatModeCacheServiceImpl implements RepeatModeCacheService {
  final SharedPreferencesAsync _pref;

  RepeatModeCacheServiceImpl({required SharedPreferencesAsync pref})
    : _pref = pref;

  @override
  void cache(AppRepeatMode repeatMode) {
    _pref.setInt(_keyRepeatMode, repeatMode.index);
  }

  @override
  Future<AppRepeatMode> getCache() async {
    int index = await _pref.getInt(_keyRepeatMode) ?? 0;
    return AppRepeatMode.values[index];
  }
}
