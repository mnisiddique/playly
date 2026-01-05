import 'package:injectable/injectable.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:playly/features/media_list/data/local/audio_data_src.dart';
import 'package:playly/features/media_list/data/model/audio_request_model.dart';
import 'package:playly/features/media_list/data/model/audio_response_model.dart';
import 'package:playly/features/media_list/domain/entity/audio_media.dart';
import 'package:playly/features/media_list/domain/repo/audio_media_repo.dart';


@Injectable(as: AudioMediaRepo)
class AudioMediaRepoImpl implements AudioMediaRepo {
  final LocalAudioSrc _localAudioSrc;

  AudioMediaRepoImpl({required LocalAudioSrc localAudioSrc})
    : _localAudioSrc = localAudioSrc;

  bool isExpectedAudioOrUnknown(SongModel song, AudioType type) {
    final map = {
      AudioType.alarm: song.isAlarm,
      AudioType.audiobook: song.isAudioBook,
      AudioType.music: song.isMusic,
      AudioType.notification: song.isNotification,
      AudioType.podcast: song.isPodcast,
      AudioType.ringtone: song.isRingtone,
    };

    final isUnknown = map.entries.every((entry) => entry.value == null);

    return map[type] == true || isUnknown;
  }

  @override
  Future<List<AudioMediaEntity>> getAudioMedia(AudioQueryParam param) async {
    final requestModel = AudioRequestModel.fromParam(param);
    List<SongModel> songs = await _localAudioSrc.getAudioMedia(requestModel);
    songs = songs
        .where((song) => isExpectedAudioOrUnknown(song, param.audioType))
        .toList();

    return songs.map((element) => element.toEntity()).toList();
  }
}
