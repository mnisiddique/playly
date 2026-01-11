import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:playly/core/app/extension/context/media_query.dart';
import 'package:playly/core/app/extension/string/casing.dart';
import 'package:playly/features/media_list/domain/entity/audio_media.dart';
import 'package:playly/features/media_list/presentation/cubit/audio_search/audio_search_cubit.dart';

import 'package:playly/features/media_list/presentation/model/audio_model.dart';
import 'package:playly/res/index.dart';

class AudioListWidget extends StatelessWidget {
  final List<AudioMediaEntity> songs;
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
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            itemCount: songs.length,
            itemBuilder: (ctx, id) {
              final song = songs[id];
              return AudioListTile(song: song);
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
  const AudioListTile({super.key, required this.song});

  final AudioMediaEntity song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      leading: AudioArtWorkWidget(song: song),
      tileColor: Colors.white,
      title: Text(
        song.title,
        maxLines: nkInt01,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: ColorGen.kCarbonBlue,
          letterSpacing: nkNegative0pt31,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            song.artistLabel.toTitleCase(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColorGen.kCharcolBlue,
              letterSpacing: nkNegative0pt15,
            ),
          ),
          Text(
            song.albumLabel.toTitleCase(),
            maxLines: nkInt01,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColorGen.kCharcolBlue,
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

  final AudioMediaEntity song;

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
          border: Border.all(
            width: nk0pt5,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          borderRadius: BorderRadius.circular(nk08),
        ),
        child: Icon(Icons.music_note_rounded),
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
