import 'package:playly/features/media_list/domain/entity/audio_media.dart';
import 'package:playly/res/index.dart';

extension AudioModel on AudioMediaEntity {
  String get artistLabel {
    final artistSmallerCase = artist.toLowerCase();
    return artistSmallerCase.contains(skUnknown) ? vskUnknownArtist : artist;
  }

  String get albumLabel {
    final albumSmallerCase = album.toLowerCase();
    return albumSmallerCase.contains(skUnknown) ||
            albumSmallerCase.contains(sk0)
        ? vskUnknownAlbum
        : album;
  }

  String get durationLabel {
    if (duration == null) {
      return vskEmpty;
    }
    final dur = Duration(milliseconds: duration!);
    int secInt = (dur.inSeconds % nk60).toInt();
    String secStr = secInt.toString().padLeft(2, '0');
    return "${dur.inMinutes}:$secStr";
  }

  String get sizeLabel {
    final mb = 1024 * 1024;
    double sizeInMb = size / mb;
    return "${sizeInMb.toStringAsFixed(nkInt02)} $vskMB";
  }
}
