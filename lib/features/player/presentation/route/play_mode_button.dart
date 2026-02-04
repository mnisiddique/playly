import 'package:flutter/material.dart';
import 'package:playly/core/app/injector/auto_injector.dart';
import 'package:playly/core/presentation/widget/neumorphic_icon_button.dart';
import 'package:playly/core/service/audio/live_playback_update.dart';
import 'package:playly/core/service/audio/play_mode_model.dart';
import 'package:playly/core/service/audio/play_mode_switch_service.dart';
import 'package:playly/core/service/cache/play_mode_cache_service.dart';
import 'package:playly/res/index.dart';

const iconByPlayMode = {
  PlayMode.none: Icon(Icons.repeat_outlined, color: ColorGen.kOrbitStroke),
  PlayMode.repeatAll: Icon(Icons.repeat_outlined, color: Colors.white),
  PlayMode.repeatCurrent: Icon(Icons.repeat_one_outlined, color: Colors.white),
  PlayMode.shuffle: Icon(Icons.shuffle_outlined, color: Colors.white),
};

class PlayerModeButton extends StatelessWidget {
  const PlayerModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayModeModel>(
      stream: getIt<LivePlayModeUpdate>().playMode,
      builder: (context, snapshot) {
        return NeumorphicIconButton(
          radius: nk24,
          gap: nk08,
          icon: iconByPlayMode[snapshot.data?.playMode ?? PlayMode.none]!,
          onTapCallback: () =>
              getIt<PlayModeSwitchService>().switchModeFrom(snapshot.data),
        );
      },
    );
  }
}
