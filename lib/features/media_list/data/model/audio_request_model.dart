import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:playly/features/media_list/domain/repo/audio_media_repo.dart';

class AudioRequestModel {
  final SongSortType sortType;
  final OrderType orderType;

  final bool ignoreCase;

  AudioRequestModel({
    required this.sortType,
    required this.orderType,

    required this.ignoreCase,
  });

  factory AudioRequestModel.fromParam(AudioQueryParam param) {
    return AudioRequestModel(
      sortType: switch (param.sortBy) {
        SortBy.album => SongSortType.ALBUM,
        SortBy.artist => SongSortType.ARTIST,
        SortBy.dateAdded => SongSortType.DATE_ADDED,
        SortBy.displayname => SongSortType.DISPLAY_NAME,
        SortBy.duration => SongSortType.DURATION,
        SortBy.title => SongSortType.TITLE,
        SortBy.size => SongSortType.SIZE,
      },
      orderType: switch (param.sortOrder) {
        SortOrder.fromLargerToSmaller => OrderType.DESC_OR_GREATER,
        SortOrder.fromSmallerToLarger => OrderType.ASC_OR_SMALLER,
      },

      ignoreCase: param.ignoreCase,
    );
  }
}
