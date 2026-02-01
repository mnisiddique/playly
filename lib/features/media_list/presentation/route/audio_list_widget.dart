import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:playly/core/app/extension/context/media_query.dart';
import 'package:playly/core/app/extension/string/casing.dart';
import 'package:playly/core/app/injector/auto_injector.dart';
import 'package:playly/core/app/navigation/named_route.dart';
import 'package:playly/core/presentation/model/audio_model.dart';
import 'package:playly/core/presentation/widget/media_item_builder.dart';
import 'package:playly/core/service/audio/audio_handler_initializer.dart';
import 'package:playly/features/media_list/domain/entity/audio_media.dart';
import 'package:playly/features/media_list/presentation/cubit/audio_search/audio_search_cubit.dart';

import 'package:playly/res/index.dart';

class AudioListWidget extends StatelessWidget {
  final List<AudioModel> songs;
  const AudioListWidget({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ListView.separated(
            separatorBuilder: (ctx, id) => Divider(
              indent: nk88, // Aligns perfectly with the start of the song title
              endIndent: nk00,
              thickness: nk0pt5,
              color: ColorGen.kOrbitStroke,
            ),
            itemCount: songs.length,
            itemBuilder: (ctx, id) {
              final song = songs[id];
              return MediaItemBuilder(
                onData: (item) {
                  final int position = item.extras![skPosition];
                  return AudioListTile(
                    song: song,
                    isPlaying: position == song.position,
                  );
                },
                onError: (error) => AudioListTile(song: song, isPlaying: false),
              );
            },
          ),
        ),
        AudioSearchUtility(),
      ],
    );
  }
}

class AudioSearchBar extends StatelessWidget {
  final bool isOpened;
  final FocusNode focusNode;
  const AudioSearchBar({
    super.key,
    required this.isOpened,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isOpened,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        if (isOpened) {
          context.read<AudioSearchCubit>().closeSearch();
          focusNode.unfocus();
        }
      },
      child: SearchBar(
        focusNode: focusNode,
        keyboardType: TextInputType.text,
        controller: isOpened ? null : TextEditingController()
          ?..clear(),
        onTap: () {
          if (!isOpened) {
            context.read<AudioSearchCubit>().openSearch();
          }
        },
        leading: const Icon(Icons.search),
        hintText: vskSearchMusic,
        elevation: WidgetStateProperty.all(6.0),
        backgroundColor: WidgetStateProperty.all(
          isOpened
              ? Theme.of(context).colorScheme.surfaceContainerHighest
              : Theme.of(context).colorScheme.primaryContainer,
        ),
        onChanged: (String value) =>
            context.read<AudioSearchCubit>().searching(value),

        trailing: isOpened
            ? [
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    context.read<AudioSearchCubit>().closeSearch();
                    focusNode.unfocus();
                  },
                ),
              ]
            : null,
      ),
    );
  }
}

class AudioSearchUtility extends StatefulWidget {
  const AudioSearchUtility({super.key});

  @override
  State<AudioSearchUtility> createState() => _AudioSearchUtilityState();
}

class _AudioSearchUtilityState extends State<AudioSearchUtility> {
  late final FocusNode _audioSearchFocusNode;

  @override
  void initState() {
    super.initState();
    _audioSearchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _audioSearchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioSearchCubit, AudioSearchState>(
      builder: (context, state) {
        final isOpened = state.maybeWhen(
          orElse: () => true,
          closed: () => false,
        );
        return AnimatedPositioned(
          duration: Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn,
          bottom: nk16,
          right: nk16,
          left: isOpened ? nk16 : context.scrSize.width - nk164,
          onEnd: () {
            if (isOpened) {
              _audioSearchFocusNode.canRequestFocus = true;
              _audioSearchFocusNode.requestFocus();
            } else {
              _audioSearchFocusNode.canRequestFocus = false;
              _audioSearchFocusNode.unfocus();
            }
          },
          child: AudioSearchBar(
            isOpened: isOpened,
            focusNode: _audioSearchFocusNode,
          ),
        );
      },
    );
  }
}

class AudioListTile extends StatelessWidget {
  final bool isPlaying;
  const AudioListTile({super.key, required this.song, required this.isPlaying});

  final AudioModel song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        getIt<AudioHandlerInitializer>().audioHandler.customAction(
          skLoadAudio,
          {skAudio: song.toMediaItem()},
        );
        context.pushNamed(NamedRoute.audioPlayer.routeName);
      },
      isThreeLine: true,
      leading: AudioArtWorkWidget(song: song.audio),
      trailing: isPlaying ? Icon(Icons.play_arrow) : null,
      title: Text(
        song.audio.title,
        maxLines: nkInt01,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: ColorGen.kActiveWhite,
          letterSpacing: nkNegative0pt31,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            song.artistLabel.toTitleCase(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              letterSpacing: nkNegative0pt15,
            ),
          ),
          Text(
            song.albumLabel.toTitleCase(),
            maxLines: nkInt01,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              letterSpacing: nkNegative0pt15,
            ),
          ),
        ],
      ),
    );
  }
}

class AudioArtWorkWidget extends StatelessWidget {
  const AudioArtWorkWidget({super.key, required this.song});

  final AudioEntity song;

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: song.id,
      type: ArtworkType.AUDIO,
      artworkHeight: nk56,
      artworkWidth: nk56,
      artworkBorder: BorderRadius.circular(nk08),
      nullArtworkWidget: Container(
        height: nk56,
        width: nk56,
        decoration: BoxDecoration(
          border: Border.all(width: nk01, color: ColorGen.kOrbitStroke),
          borderRadius: BorderRadius.circular(nk08),
        ),
        child: Icon(Icons.music_note_rounded, color: Colors.white54),
      ),
    );
  }
}

/**
 * 1. When to choose circular avatar and when to choose square avatar for list item
 * 2. Does M3 suggests square avatar alaways for list item? Is there any suggestion for music item?
 * Ans: 
 *      Feature,Design Choice,M3 Logic
        Shape,Rounded Square,"Identifies the item as ""Media Content."""
        Corner Radius,8dp,"Softens the UI and aligns with M3 ""Small"" shapes."
        Size,56x56dp,Standard for two-line list items (Title + Artist).
        Placeholder,Colored Square + Icon,"Maintains the ""Content"" shape even when art is missing."
 * 
 * 3. In case of showing music list item as they are not grouped by album should i use rounded corner?
 *    Ans: No, keep it edge to edge
 * 4. Should i use elevation for list item?
 *    Ans:- no, 
 * 5. Should i use border for list item?
 *    Ans: The Row (The "Line" between items): Instead of a border around the whole item, use a Horizontal Divider.
          M3 Pro-Tip: The divider should be "inset." It should start where the text starts, not under the album art. This keeps the list looking "connected" but organized.
          The Thumbnail: If an album cover is very white/light and your app background is also white, the image might "bleed" into the background. In this specific case, a very thin 0.5dp inner stroke (using surfaceVariant color) around the image helps define its shape.
 * 
 * Additional question
 * 1. what is tonal elevation
 */
