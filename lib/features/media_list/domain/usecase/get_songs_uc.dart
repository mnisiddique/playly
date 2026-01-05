import 'package:injectable/injectable.dart';
import 'package:playly/features/media_list/domain/entity/audio_media.dart';
import 'package:playly/features/media_list/domain/repo/audio_media_repo.dart';

@Injectable()
class GetSongsUc {
  final AudioMediaRepo _audioMediaRepo;

  GetSongsUc({required AudioMediaRepo audioMediaRepo})
    : _audioMediaRepo = audioMediaRepo;

  Future<List<AudioMediaEntity>> call() async {
    return _audioMediaRepo.getAudioMedia(AudioQueryParam());
  }
}
