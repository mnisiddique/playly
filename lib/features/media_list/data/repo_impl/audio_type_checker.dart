import 'package:injectable/injectable.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:playly/features/media_list/domain/repo/audio_media_repo.dart';

abstract class AudioTypeChecker {
  Map<AudioType, bool?> checkerMap(SongModel song) {
    return {
      AudioType.alarm: song.isAlarm,
      AudioType.audiobook: song.isAudioBook,
      AudioType.music: song.isMusic,
      AudioType.notification: song.isNotification,
      AudioType.podcast: song.isPodcast,
      AudioType.ringtone: song.isRingtone,
    };
  }

  bool checkTypeOf(SongModel model);
}

class MusicChecker extends AudioTypeChecker {
  @override
  bool checkTypeOf(SongModel model) {
    final map = checkerMap(model);
    int duration = model.duration ?? -1;
    final durationObject = duration < 0
        ? Duration.zero
        : Duration(milliseconds: duration);
    return map[AudioType.music] == true && durationObject.inMinutes >= 1;
  }
}

class ToneChecker extends AudioTypeChecker {
  @override
  bool checkTypeOf(SongModel model) {
    final map = checkerMap(model);
    final flags = [
      map[AudioType.alarm],
      map[AudioType.ringtone],
      map[AudioType.notification],
    ];

    return flags.contains(true);
  }
}

class AudioBookChecker extends AudioTypeChecker {
  @override
  bool checkTypeOf(SongModel model) {
    final map = checkerMap(model);
    return map[AudioType.audiobook] == true;
  }
}

class PodcastChecker extends AudioTypeChecker {
  @override
  bool checkTypeOf(SongModel model) {
    final map = checkerMap(model);
    return map[AudioType.podcast] == true;
  }
}

@Injectable()
class GetAudioTypeChecker {
  AudioTypeChecker call(AudioType type) {
    final map = {
      AudioType.alarm: ToneChecker(),
      AudioType.audiobook: AudioBookChecker(),
      AudioType.music: MusicChecker(),
      AudioType.notification: ToneChecker(),
      AudioType.podcast: PodcastChecker(),
      AudioType.ringtone: ToneChecker(),
    };
    return map[type]!;
  }
}
