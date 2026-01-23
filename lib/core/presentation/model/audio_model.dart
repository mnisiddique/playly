import 'package:audio_service/audio_service.dart';
import 'package:playly/core/app/extension/duration/duration_formatter.dart';
import 'package:playly/features/media_list/domain/entity/audio_media.dart';
import 'package:playly/res/index.dart';

class AudioModel {
  final AudioEntity audio;
  final int position;
  AudioModel({required this.audio, required this.position});
  String get artistLabel {
    final artistSmallerCase = audio.artist.toLowerCase();
    return artistSmallerCase.contains(skUnknown)
        ? vskUnknownArtist
        : audio.artist;
  }

  String get albumLabel {
    final albumSmallerCase = audio.album.toLowerCase();
    return albumSmallerCase.contains(skUnknown) ||
            albumSmallerCase.contains(sk0)
        ? vskUnknownAlbum
        : audio.album;
  }

  Duration? get audioDuration =>
      audio.duration == null ? null : Duration(milliseconds: audio.duration!);

  String get durationLabel {
    if (audioDuration == null) {
      return vskNA;
    }
    return audioDuration!.toMMSS();
  }

  String get sizeLabel {
    final mb = 1024 * 1024;
    double sizeInMb = audio.size / mb;
    return "${sizeInMb.toStringAsFixed(nkInt02)} $vskMB";
  }

  MediaItem toMediaItem() {
    return MediaItem(
      id: audio.id.toString(),
      title: audio.title,
      album: albumLabel,
      artist: artistLabel,
      duration: audioDuration,
      extras: {
        skUri: audio.uri,
        skSizeLabel: sizeLabel,
        skDurationLabel: durationLabel,
      },
    );
  }
}
