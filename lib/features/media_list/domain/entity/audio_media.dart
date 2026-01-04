class AudioMediaEntity {
  final String title;
  final String artist;
  final String album;
  final int id;
  final int size;
  final int? duration;

  AudioMediaEntity({
    required this.title,
    required this.artist,
    required this.album,
    required this.id,
    required this.size,
    required this.duration,
  });
}
