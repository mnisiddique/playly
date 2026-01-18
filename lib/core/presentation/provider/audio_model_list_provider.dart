import 'package:injectable/injectable.dart';
import 'package:playly/core/presentation/model/audio_model.dart';

 List<AudioModel> _audioModels = [];

@Injectable()
class AudioModelListProvider {
  const AudioModelListProvider();

  List<AudioModel> getAudioModels() {
    return _audioModels;
  }
  void setAudioModels(List<AudioModel> audioModels) {
    _audioModels = audioModels;
  }
}