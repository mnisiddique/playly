import 'package:playly/features/media_list/domain/entity/audio_media.dart';
import 'package:playly/res/index.dart';

class AudioModel {
  final AudioEntity audio;
  final int position;
  AudioModel({required this.audio, required this.position});
  String get artistLabel {
    final artistSmallerCase = audio.artist.toLowerCase();
    return artistSmallerCase.contains(skUnknown) ? vskUnknownArtist : audio.artist;
  }

  String get albumLabel {
    final albumSmallerCase = audio.album.toLowerCase();
    return albumSmallerCase.contains(skUnknown) ||
            albumSmallerCase.contains(sk0)
        ? vskUnknownAlbum
        : audio.album;
  }

  String get durationLabel {
    if (audio.duration == null) {
      return vskEmpty;
    }
    final dur = Duration(milliseconds: audio.duration!);
    int secInt = (dur.inSeconds % nk60).toInt();
    String secStr = secInt.toString().padLeft(2, '0');
    return "${dur.inMinutes}:$secStr";
  }

  String get sizeLabel {
    final mb = 1024 * 1024;
    double sizeInMb = audio.size / mb;
    return "${sizeInMb.toStringAsFixed(nkInt02)} $vskMB";
  }
}
