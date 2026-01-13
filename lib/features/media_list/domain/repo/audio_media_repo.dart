import 'package:playly/features/media_list/domain/entity/audio_media.dart';

abstract class AudioMediaRepo {
  Future<List<AudioEntity>> getAudioMedia(AudioQueryParam param);
}

enum SortOrder { fromSmallerToLarger, fromLargerToSmaller }

enum SortBy { title, artist, album, duration, dateAdded, size, displayname }

enum AudioType { alarm, ringtone, podcast, notification, music, audiobook }

class AudioQueryParam {
  final SortOrder sortOrder;
  final SortBy sortBy;
  final AudioType audioType;
  final bool ignoreCase;

  AudioQueryParam({
    this.sortOrder = SortOrder.fromSmallerToLarger,
    this.sortBy = SortBy.displayname,
    this.audioType = AudioType.music,
    this.ignoreCase = true,
  });
}
