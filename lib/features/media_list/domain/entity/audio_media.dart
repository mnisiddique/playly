class AudioEntity {
  final String title;
  final String artist;
  final String album;
  final int id;
  final int size;
  final int? duration;

  AudioEntity({
    required this.title,
    required this.artist,
    required this.album,
    required this.id,
    required this.size,
    required this.duration,
  });
}
