import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:playly/features/media_list/domain/entity/audio_media.dart';
import 'package:playly/features/media_list/presentation/model/audio_model.dart';
import 'package:playly/res/index.dart';

class AudioListWidget extends StatelessWidget {
  final List<AudioMediaEntity> songs;
  const AudioListWidget({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: nk16, vertical: nk08),
      child: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (ctx, id) {
          final song = songs[id];
          return AudioListTile(song: song);
        },
      ),
    );
  }
}

class AudioListTile extends StatelessWidget {
  const AudioListTile({super.key, required this.song});

  final AudioMediaEntity song;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        padding: EdgeInsets.all(nk08),
        decoration: BoxDecoration(
          color: ColorGen.kWhiteColor,
          borderRadius: BorderRadius.all(Radius.circular(nk10)),
          // border: Border.symmetric(horizontal: BorderSide(width: nk0pt5, color: ColorGen.kSilverFog)),
          border: Border.all(width: nk0pt5, color: ColorGen.kSilverFog),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AudioArtWorkWidget(song: song),
            Gap(nk08),
            Expanded(child: AudioDataWidget(song: song)),
          ],
        ),
      ),
    );
  }
}

class AudioDataWidget extends StatelessWidget {
  final AudioMediaEntity song;
  const AudioDataWidget({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          song.title,
          maxLines: nkInt01,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: ColorGen.kCarbonBlue,
            letterSpacing: nkNegative0pt31,
          ),
        ),
        Text(
          song.artistLabel,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ColorGen.kCharcolBlue,
            letterSpacing: nkNegative0pt15,
          ),
        ),
        Text(
          song.albumLabel,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ColorGen.kCharcolBlue,
            letterSpacing: nkNegative0pt15,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              song.sizeLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorGen.kCharcolBlue,
                letterSpacing: nkNegative0pt15,
              ),
            ),
            Text(
              song.durationLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorGen.kElectricBlue,
                letterSpacing: nkNegative0pt15,
              ),
            ),
          ],
        ),
      ],
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
      artworkHeight: nk56,
      artworkWidth: nk56,
      type: ArtworkType.AUDIO,
      nullArtworkWidget: CircleAvatar(
        radius: nk28,
        child: ClipOval(child: AssetGen.artwork.noArtwork.image(height: nk56, width: nk56, fit: BoxFit.cover)),
      ),
    );
  }
}
