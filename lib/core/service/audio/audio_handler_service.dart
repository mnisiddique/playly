import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:playly/core/service/audio/audio_session_service.dart';
import 'package:playly/core/service/cache/repeat_mode_cache_service.dart';
import 'package:playly/res/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioHandlerService extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _audioPlayer;
  final AudioSessionService _sessionService;
  final RepeatModeCacheService _repeatModeCache;

  int currentPlayingIndex = -1;

  AudioHandlerService({
    required AudioPlayer audioPlayer,
    required AudioSessionService sessionService,
    required RepeatModeCacheService repeatModeCache,
  }) : _sessionService = sessionService,
       _audioPlayer = audioPlayer,
       _repeatModeCache = repeatModeCache {
    setInitialPlaybackState();
    notifyAudioHandlerAboutPlaybackEvents();
    loadRepeatMode();
    listenAutoAudioChange();
  }

  void listenAutoAudioChange() {
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null &&
          queue.value.isNotEmpty &&
          index < queue.value.length) {
        mediaItem.add(queue.value[index]);
        currentPlayingIndex = index;
      }
    });
  }

  void setInitialPlaybackState() {
    playbackState.add(
      PlaybackState(
        controls: [MediaControl.play],
        processingState: AudioProcessingState.idle,
        playing: false,
      ),
    );
  }

  factory AudioHandlerService.fromDependency() {
    return AudioHandlerService(
      audioPlayer: AudioPlayer(),
      sessionService: AudioSessionServiceImpl(),
      repeatModeCache: RepeatModeCacheServiceImpl(
        pref: SharedPreferencesAsync(),
      ),
    );
  }

  void loadAudio(MediaItem mediaItemObject) async {
    try {
      await _sessionService.configAudioSession(_audioPlayer);

      currentPlayingIndex = mediaItemObject.extras![skPosition];

      await _audioPlayer.seek(Duration.zero, index: currentPlayingIndex);

      mediaItem.add(mediaItemObject);
      play();
    } catch (e) {
      playbackState.add(
        playbackState.value.copyWith(
          processingState: AudioProcessingState.error,
          errorMessage: "$vskFailedToLoadAdio $e",
        ),
      );
    }
  }

  void notifyAudioHandlerAboutPlaybackEvents() {
    _audioPlayer.playbackEventStream.listen(
      (PlaybackEvent event) {
        final playing = _audioPlayer.playing;
        playbackState.add(
          playbackState.value.copyWith(
            controls: [
              MediaControl.skipToPrevious,
              if (playing) MediaControl.pause else MediaControl.play,
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
            }[_audioPlayer.processingState]!,
            playing: playing,
            updatePosition: _audioPlayer.position,
            bufferedPosition: _audioPlayer.bufferedPosition,
            speed: _audioPlayer.speed,
            queueIndex:
                _audioPlayer.currentIndex ??
                (currentPlayingIndex < 0 ? 0 : currentPlayingIndex),
          ),
        );
      },
      onError: (e, st) {
        playbackState.add(
          playbackState.value.copyWith(
            processingState: AudioProcessingState.error,
            errorMessage: "$vskFailedToLoadAdio $e",
          ),
        );
      },
    );
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        await _audioPlayer.setLoopMode(LoopMode.off);
        await setShuffleMode(AudioServiceShuffleMode.all);
        _repeatModeCache.cache(AppRepeatMode.none);
        break;
      case AudioServiceRepeatMode.one:
        await _audioPlayer.setLoopMode(LoopMode.one);
        await setShuffleMode(AudioServiceShuffleMode.none);
        _repeatModeCache.cache(AppRepeatMode.current);
        break;
      case AudioServiceRepeatMode.all:
      case AudioServiceRepeatMode.group:
        await _audioPlayer.setLoopMode(LoopMode.all);
        await setShuffleMode(AudioServiceShuffleMode.none);
        _repeatModeCache.cache(AppRepeatMode.all);
        break;
    }
    playbackState.add(playbackState.value.copyWith(repeatMode: repeatMode));
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      await _audioPlayer.setShuffleModeEnabled(false);
    } else {
      // This randomizes the internal order of the playlist
      await _audioPlayer.shuffle();
      await _audioPlayer.setShuffleModeEnabled(true);
    }

    // Update the state so the shuffle icon changes color in your UI
    playbackState.add(playbackState.value.copyWith(shuffleMode: shuffleMode));
  }

  Future<void> loadRepeatMode() async {
    final mode = await _repeatModeCache.getCache();
    setRepeatMode(fromAppRepeatMode(mode));
  }

  AudioServiceRepeatMode fromAppRepeatMode(AppRepeatMode mode) =>
      switch (mode) {
        AppRepeatMode.all => AudioServiceRepeatMode.all,
        AppRepeatMode.current => AudioServiceRepeatMode.one,
        AppRepeatMode.none => AudioServiceRepeatMode.none,
      };

  @override
  Future<dynamic> customAction(String name, [Map<String, dynamic>? extras]) async {
    switch (name) {
      case skLoadAudio:
        loadAudio(extras![skAudio] as MediaItem);
        return true;
      default:
        return super.customAction(name, extras);
    }
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    if (queue.value.isEmpty) {
      queue.add(List<MediaItem>.from(mediaItems));
      final audioSources = mediaItems.map((item) {
        return AudioSource.uri(
          item.extras![skUri],
          tag: item, // Link the metadata to the audio source
        );
      }).toList();
      await _audioPlayer.setAudioSources(audioSources);
    }
  }

  @override
  Future<void> play() {
    return _audioPlayer.play();
  }

  @override
  Future<void> pause() {
    return _audioPlayer.pause();
  }

  @override
  Future<void> stop() async {
    await _audioPlayer.stop();
    // 2. Broadcast the 'idle' state so the notification disappears
    playbackState.add(
      playbackState.value.copyWith(
        playing: false,
        processingState: AudioProcessingState.idle,
      ),
    );
    // 3. Very important: Call super.stop()
    // This tells audio_service to shut down the background isolate
    await super.stop();
  }

  @override
  Future<void> skipToNext() {
    return _audioPlayer.seekToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    return _audioPlayer.seekToPrevious();
  }

  @override
  Future<void> seek(Duration position) {
    return _audioPlayer.seek(position);
  }

  @override
  Future<void> onNotificationDeleted() async {
    await stop();
  }

  @override
  Future<void> onTaskRemoved() async {
    final bool isPlaying = playbackState.value.playing;

    if (!isPlaying) {
      await stop();
      await super.onTaskRemoved();
    }
  }
}
