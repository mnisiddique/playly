```dart
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();

  MyAudioHandler() {
    // 1. Broadcast the current media item (song info)
    // 2. Broadcast the playback state (playing, pausing, seeking)
    _notifyAudioHandlerAboutPlaybackEvents();
  }

  // Define what the notification buttons do
  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }

  // Load a song and update the notification UI
  Future<void> loadTrack(String url, String title, String artist, String artUrl) async {
    final duration = await _player.setUrl(url);
    
    mediaItem.add(MediaItem(
      id: url,
      album: "Streaming Media",
      title: title,
      artist: artist,
      duration: duration,
      artUri: Uri.parse(artUrl),
    ));
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }
}
```
