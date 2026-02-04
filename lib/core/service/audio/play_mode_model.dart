import 'package:audio_service/audio_service.dart';
import 'package:playly/core/service/cache/play_mode_cache_service.dart';

const playModeByRepeatMode = {
  AudioServiceRepeatMode.none: PlayMode.none,
  AudioServiceRepeatMode.all: PlayMode.repeatAll,
  AudioServiceRepeatMode.one: PlayMode.repeatCurrent,
  AudioServiceRepeatMode.group: PlayMode.repeatAll,
};

const playModeByShuffleMode = {
  AudioServiceShuffleMode.none: PlayMode.none,
  AudioServiceShuffleMode.all: PlayMode.shuffle,
  AudioServiceShuffleMode.group: PlayMode.shuffle,
};

class PlayModeModel {
  final PlayMode playMode;

  PlayModeModel({required this.playMode});

  factory PlayModeModel.fromPlaybackState(PlaybackState state) {
    final playModeFromShuffle =
        playModeByShuffleMode[state.shuffleMode] ?? PlayMode.none;
    final playModeFromRepeat =
        playModeByRepeatMode[state.repeatMode] ?? PlayMode.none;

    if (playModeFromRepeat != PlayMode.none) {
      return PlayModeModel(playMode: playModeFromRepeat);
    }
    if (playModeFromShuffle != PlayMode.none) {
      return PlayModeModel(playMode: playModeFromShuffle);
    }
    return PlayModeModel(playMode: PlayMode.none);
  }

  AudioServiceShuffleMode toShuffleMode() => switch (playMode) {
    PlayMode.none => AudioServiceShuffleMode.none,
    PlayMode.repeatAll => AudioServiceShuffleMode.none,
    PlayMode.repeatCurrent => AudioServiceShuffleMode.none,
    PlayMode.shuffle => AudioServiceShuffleMode.all,
  };
  AudioServiceRepeatMode toRepeatMode() => switch (playMode) {
    PlayMode.none => AudioServiceRepeatMode.none,
    PlayMode.repeatAll => AudioServiceRepeatMode.all,
    PlayMode.repeatCurrent => AudioServiceRepeatMode.one,
    PlayMode.shuffle => AudioServiceRepeatMode.none,
  };
}

/**
 * 
 * PlayModeModel -(used in)-  in service, UI, stream mapping, it should be in audio_service
 * PlayModeSwitch should be in Presentation Layer as it will be used only in presentation
 * 
 * Conversion
 * From service mode to play mode
 * From play mode to service mode

 * 
 * There should be a PlayModeSwitch class which will switch mode from existing mode
 * 
 * PlayModeSwitch{
 * void switchModeFrom(PlayMode current)
 * }
 */
