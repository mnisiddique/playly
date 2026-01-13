import 'package:injectable/injectable.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:playly/features/media_list/data/local/audio_data_src.dart';
import 'package:playly/features/media_list/data/model/audio_request_model.dart';
import 'package:playly/features/media_list/data/model/audio_response_model.dart';
import 'package:playly/features/media_list/data/repo_impl/audio_type_checker.dart';
import 'package:playly/features/media_list/domain/entity/audio_media.dart';
import 'package:playly/features/media_list/domain/repo/audio_media_repo.dart';

@Injectable(as: AudioMediaRepo)
class AudioMediaRepoImpl implements AudioMediaRepo {
  final LocalAudioSrc _localAudioSrc;
  final GetAudioTypeChecker _getAudioTypeChecker;

  AudioMediaRepoImpl({
    required LocalAudioSrc localAudioSrc,
    required GetAudioTypeChecker getAudioTypeChecker,
  }) : _getAudioTypeChecker = getAudioTypeChecker,
       _localAudioSrc = localAudioSrc;

  @override
  Future<List<AudioEntity>> getAudioMedia(AudioQueryParam param) async {
    final requestModel = AudioRequestModel.fromParam(param);
    List<SongModel> songs = await _localAudioSrc.getAudioMedia(requestModel);
    songs = songs
        .where(
          (song) => _getAudioTypeChecker(param.audioType).checkTypeOf(song),
        )
        .toList();

    return songs.map((element) => element.toEntity()).toList();
  }
}
