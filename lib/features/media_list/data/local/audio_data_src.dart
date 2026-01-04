import 'package:injectable/injectable.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:playly/features/media_list/data/model/audio_request_model.dart';

abstract class LocalAudioSrc {
  Future<List<SongModel>> getAudioMedia(AudioRequestModel model);
}

@Injectable(as: LocalAudioSrc)
class LocalAudioSrcImpl implements LocalAudioSrc {
  final OnAudioQuery _audioQuery;

  LocalAudioSrcImpl({required OnAudioQuery audioQuery})
    : _audioQuery = audioQuery;

  @override
  Future<List<SongModel>> getAudioMedia(AudioRequestModel model) async {
    return await _audioQuery.querySongs(
      sortType: model.sortType,
      orderType: model.orderType,
      ignoreCase: model.ignoreCase,
    );
  }
}
