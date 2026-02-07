import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_box/features/music_feature/data/models/my_music_model.dart';
import 'package:music_box/features/music_feature/data/models/my_playlist_model.dart';
import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_cubit.dart';
import 'package:music_box/features/music_feature/presentation/cubits/playlist_cubit/playlist_cubit.dart';

double _appTopBarHeight = 60;

class SliverPlaylistAppBar extends SliverPersistentHeaderDelegate {
  final MyPlaylistModel playlist;
  final List<MyMusicModel> songs;

  SliverPlaylistAppBar({required this.playlist, required this.songs});
  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    var shrinkPercentage =
        min(1, shrinkOffset / (maxExtent - minExtent)).toDouble();

    return Stack(
      clipBehavior: Clip.hardEdge,
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: _appTopBarHeight,
            color: Colors.transparent,
          ),
        ),
        Column(
          children: [
            Flexible(
              flex: 1,
              child: Stack(
                children: [
                  ClipRRect(
                    child: Container(
                      foregroundDecoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          tileMode: TileMode.mirror,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                          ],
                        ),
                      ),
                      height: _appTopBarHeight + 35,
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: playlist.image!,
                            height: 40,
                            fit: BoxFit.cover,
                            maxHeightDiskCache: 40,
                            maxWidthDiskCache:
                                MediaQuery.of(context).size.width.round(),
                            memCacheHeight:
                                (40 * MediaQuery.of(context).devicePixelRatio)
                                    .round(),
                            memCacheWidth: (MediaQuery.of(context).size.width *
                                    MediaQuery.of(context).devicePixelRatio)
                                .round(),
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.topLeft,
                          ),
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                            child: Container(
                              height: 60,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 1 - shrinkPercentage,
                    child: Container(
                      height: 400,
                      width: MediaQuery.of(context).size.width,
                      foregroundDecoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          alignment: FractionalOffset.topCenter,
                          image: CachedNetworkImageProvider(playlist.image!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            DecoratedBox(
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                  offset: Offset(0, -23),
                  spreadRadius: 2,
                  blurRadius: 50,
                )
              ]),
              child: ClipRRect(
                child: SizedBox(
                  height: 60,
                  child: Stack(
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                        child: SizedBox(
                          height: 70,
                          child: Opacity(
                            opacity: max(1 - shrinkPercentage * 2, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                BlocBuilder<PlaylistCubit, PlaylistState>(
                                  builder: (context, state) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 3, right: 3),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              context
                                                  .read<PlaylistCubit>()
                                                  .onSortByDuration(songs);
                                            },
                                            icon: const Icon(
                                              Icons.timer_rounded,
                                            ),
                                            color: state.sortByDuration
                                                ? Colors.white
                                                : Colors.grey.shade700,
                                            iconSize: 22,
                                            splashRadius: 22,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              context
                                                  .read<PlaylistCubit>()
                                                  .onSortByName(songs);
                                            },
                                            visualDensity: const VisualDensity(
                                                horizontal: -3),
                                            icon: const Icon(
                                              Icons.sort_by_alpha_rounded,
                                            ),
                                            color: state.sortByName
                                                ? Colors.white
                                                : Colors.grey.shade700,
                                            iconSize: 22,
                                            splashRadius: 22,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              context
                                                  .read<PlaylistCubit>()
                                                  .onAscendNDescend(songs);
                                            },
                                            icon: state.isAscending
                                                ? const Icon(Icons
                                                    .arrow_downward_rounded)
                                                : const Icon(
                                                    Icons.arrow_upward_rounded),
                                            splashRadius: 22,
                                            color: Colors.white,
                                            iconSize: 22,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        Stack(
          clipBehavior: Clip.hardEdge,
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 35,
                  ),
                  SizedBox(
                    height: _appTopBarHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        Flexible(
                          child: Opacity(
                            opacity: shrinkPercentage,
                            child: Text(
                              playlist.title!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: max(1 - shrinkPercentage * 6, 0),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 70,
                child: Opacity(
                  opacity: max(1 - shrinkPercentage * 2, 0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: Text(
                            playlist.title!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 14, bottom: 10, top: 5),
                          child: Text(
                            playlist.subtitle!,
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 10),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.music_note_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              Text(
                                '${songs.length} songs',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              const Icon(
                                Icons.visibility,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                playlist.view!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            Positioned(
                bottom: 10,
                right: 10,
                child: InkWell(
                  onTap: () {
                    context.read<MusicCubit>().playPlayList(songs, 0);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.redAccent),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ],
    );
  }

  @override
  double get maxExtent => 400;

  @override
  double get minExtent => 110;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
