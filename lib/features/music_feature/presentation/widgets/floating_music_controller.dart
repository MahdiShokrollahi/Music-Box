import 'dart:io';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_box/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:music_box/core/services/audio_manger.dart';
import 'package:music_box/core/services/downlaod_manager.dart';
import 'package:music_box/core/services/service_locator.dart';
import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_cubit.dart';
import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_state.dart';
import 'package:music_box/features/music_feature/presentation/screens/player_screen.dart';

class FloatingMusicController extends StatefulWidget {
  FloatingMusicController(this.state, {super.key});
  MusicState state;

  @override
  State<FloatingMusicController> createState() =>
      _FloatingMusicControllerState();
}

class _FloatingMusicControllerState extends State<FloatingMusicController>
    with SingleTickerProviderStateMixin {
  late AnimationController playAnimationController;
  late Animation<double> playAnimation;

  void _playPauseOnPressed(MusicState state) {
    if (state.musicControllerStatus is MusicControllerPlayingStatus) {
      context.read<MusicCubit>().pause();
      playAnimationController.forward();
    } else {
      context.read<MusicCubit>().play();
      playAnimationController.reverse();
    }
  }

  @override
  void initState() {
    playAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    playAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(playAnimationController);
    context.read<MusicCubit>().listenForPlaylistChange();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final ThemeData themeData = Theme.of(context);
    return BlocProvider(
      create: (context) => locator<ThemeCubit>(),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              barrierColor:
                  themeData.colorScheme.secondaryContainer.withOpacity(0.96),
              builder: (context) {
                return const FractionallySizedBox(
                    heightFactor: 0.95, child: PlayerScreen());
              });
        },
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 60,
                  width: width,
                  color: state.primaryColor.withOpacity(0.90),
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Stack(
                    children: [
                      StreamBuilder<SequenceState?>(
                          stream: player.sequenceStateStream,
                          builder: (context, snapShot) {
                            final state = snapShot.data;
                            if (state?.sequence.isEmpty ?? true) {
                              return const SizedBox();
                            }
                            final metaData =
                                state!.currentSource!.tag as MediaItem;
                            if (DownLoadManager.isSongDownloaded(metaData.id)) {
                              context.read<ThemeCubit>().setTheme(
                                  FileImage(File.fromUri(metaData.artUri!)));
                            }
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: DownLoadManager.isSongDownloaded(
                                      metaData.id)
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            image: DecorationImage(
                                              image: FileImage(
                                                  File.fromUri(
                                                      metaData.artUri!),
                                                  scale: 7),
                                              centerSlice: const Rect.fromLTRB(
                                                  1, 1, 1, 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 50,
                                      width: 50,
                                      margin: const EdgeInsets.only(left: 12),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                            imageBuilder:
                                                (context, imageProvider) {
                                              context
                                                  .read<ThemeCubit>()
                                                  .setTheme(imageProvider);
                                              return Image(
                                                image: imageProvider,
                                                fit: BoxFit.fitHeight,
                                              );
                                            },
                                            imageUrl:
                                                metaData.artUri.toString()),
                                      ),
                                    ),
                            );
                          }),
                      StreamBuilder<SequenceState?>(
                          stream: player.sequenceStateStream,
                          builder: (context, snapShot) {
                            final playerState = snapShot.data;
                            if (playerState?.sequence.isEmpty ?? true) {
                              return const SizedBox();
                            }
                            final metaData =
                                playerState!.currentSource!.tag as MediaItem;
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 70, top: 4, bottom: 0, right: 122),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      metaData.title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: state.textColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      metaData.artist!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          color:
                                              state.textColor.withOpacity(0.8),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                StreamBuilder<PlayerState>(
                                    stream: player.playerStateStream,
                                    builder: (context, snapShot) {
                                      final playerState = snapShot.data;
                                      final processingState =
                                          playerState?.processingState;
                                      bool playing =
                                          playerState?.playing ?? false;
                                      playing
                                          ? playAnimationController.forward()
                                          : playAnimationController.reverse();
                                      return IconButton(
                                          onPressed: () {
                                            _playPauseOnPressed(widget.state);
                                          },
                                          splashColor: Colors.redAccent,
                                          padding: const EdgeInsets.all(12),
                                          icon: AnimatedIcon(
                                            icon: AnimatedIcons.play_pause,
                                            progress: playAnimation,
                                            size: 34,
                                            color: Colors.red,
                                          ));
                                    }),
                                BlocBuilder<MusicCubit, MusicState>(
                                  builder: (context, state) {
                                    return StreamBuilder<SequenceState?>(
                                        stream: player.sequenceStateStream,
                                        builder: (context, snapShot) {
                                          final data = snapShot.data;
                                          if (data?.sequence.isEmpty ?? true) {
                                            return const SizedBox();
                                          }
                                          final isLasSong = state
                                                  .currentQueue.isEmpty ||
                                              state.currentQueue.last.id ==
                                                  data!.currentSource!.tag.id;
                                          return IconButton(
                                              onPressed: () {
                                                !isLasSong
                                                    ? context
                                                        .read<MusicCubit>()
                                                        .next()
                                                    : null;
                                              },
                                              splashColor: Colors.redAccent,
                                              padding: const EdgeInsets.all(12),
                                              icon: Icon(
                                                CupertinoIcons.forward_fill,
                                                size: 28,
                                                color: Colors.grey.withOpacity(
                                                    !isLasSong ? 1.0 : 0.3),
                                              ));
                                        });
                                  },
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
