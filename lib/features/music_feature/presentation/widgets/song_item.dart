import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_box/core/helper/formatter.dart';
import 'package:music_box/core/widgets/marqwee_widget.dart';
import 'package:music_box/features/download_feature/presentation/widgets/download_button.dart';
import 'package:music_box/features/music_feature/data/models/my_music_model.dart';
import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_cubit.dart';

class SongItem extends StatelessWidget {
  SongItem(
      {super.key,
      required this.song,
      required this.playlist,
      required this.index});
  final MyMusicModel song;
  final int index;
  final List<MyMusicModel> playlist;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<MusicCubit>().playPlayList(playlist, index);
      },
      splashColor: Colors.red.withOpacity(0.4),
      hoverColor: Colors.red.withOpacity(0.4),
      focusColor: Colors.red.withOpacity(0.4),
      highlightColor: Colors.red.withOpacity(0.4),
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              width: 60,
              height: 60,
              imageUrl: '${song.lowResImage}',
              imageBuilder: (context, imageProvider) => DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: imageProvider,
                    centerSlice: const Rect.fromLTRB(1, 1, 1, 1),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MarqueeWidget(
                      child: Text(
                    song.title!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                  )),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    overflow: TextOverflow.ellipsis,
                    song.moreInfo!.singers!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              color: Colors.red,
              iconSize: 22,
              icon: const Icon(Icons.favorite_outline),
              onPressed: () => {},
            ),
            Column(
              children: [
                DownloadButton(song: song),
                Text(
                  Helper.formatTime(song.duration!),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
