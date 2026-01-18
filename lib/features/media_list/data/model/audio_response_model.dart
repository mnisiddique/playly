import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:playly/features/media_list/domain/entity/audio_media.dart';
import 'package:playly/res/visible_string/visible_string.dart';

extension AudioResponseModel on SongModel {
  AudioEntity toEntity() {
    return AudioEntity(
      title: displayName,
      artist: artist ?? vskUnknownArtist,
      album: album ?? vskUnknownAlbum,
      id: id,
      size: size,
      duration: duration,
      uri: Uri.parse(uri!),
    );
  }
}
