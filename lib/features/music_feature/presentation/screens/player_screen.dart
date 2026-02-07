import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_box/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:music_box/core/services/audio_manger.dart';
import 'package:music_box/core/services/downlaod_manager.dart';
import 'package:music_box/core/services/service_locator.dart';
import 'package:music_box/core/utils/models/position_data.dart';
import 'package:music_box/core/widgets/marqwee_widget.dart';
import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_cubit.dart';
import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_state.dart';
import 'package:music_box/features/music_feature/presentation/widgets/forward_button.dart';
import 'package:music_box/features/music_feature/presentation/widgets/inner_shadow.dart';
import 'package:music_box/features/music_feature/presentation/widgets/loop_button.dart';
import 'package:music_box/features/music_feature/presentation/widgets/player_progress_bar.dart';
import 'package:music_box/features/music_feature/presentation/widgets/playlist_widget.dart';
import 'package:music_box/features/music_feature/presentation/widgets/previous_button.dart';
import 'package:music_box/features/music_feature/presentation/widgets/shuffle_button.dart';
import 'package:rxdart/rxdart.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with TickerProviderStateMixin {
  late AnimationController playAnimationController;
  late Animation<double> playAnimation;
  late TabController _tabController;
  late CustomSegmentedController<int> _segmentedController;

  int page = 0;

  void _playPauseOnPressed(MusicState state) {
    if (state.musicControllerStatus is MusicControllerPlayingStatus) {
      context.read<MusicCubit>().pause();
      playAnimationController.forward();
    } else {
      context.read<MusicCubit>().play();
      playAnimationController.reverse();
    }
    setState(() {});
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _segmentedController = CustomSegmentedController();
    playAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    playAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(playAnimationController);
    playAnimationController.value = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: themeData.colorScheme.surface,
            systemNavigationBarDividerColor: themeData.colorScheme.surface),
        child: BlocProvider<ThemeCubit>.value(
          value: locator<ThemeCubit>(),
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return Container(
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                    color: state.primaryColor.withOpacity(0.90),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: themeData.colorScheme.secondary.withOpacity(.1),
                        blurRadius: 6.0,
                        spreadRadius: 2.0,
                        offset: const Offset(
                          0.0,
                          -2.0,
                        ),
                      ),
                    ]),
                child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      toolbarHeight: 76,
                      backgroundColor: Colors.transparent,
                      systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarIconBrightness: Brightness.dark,
                          systemNavigationBarColor:
                              themeData.colorScheme.secondaryContainer,
                          systemNavigationBarIconBrightness: Brightness.dark,
                          statusBarBrightness: Brightness.light,
                          statusBarColor: Colors.transparent),
                      leadingWidth: 0,
                      leading: Container(),
                      titleSpacing: 0,
                      title: Container(
                        margin:
                            const EdgeInsets.only(top: 4, left: 20, right: 20),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: InnerShadow(
                                shadows: [
                                  BoxShadow(
                                    color: themeData.colorScheme.secondary
                                        .withOpacity(.2),
                                    blurRadius: 3.0,
                                    spreadRadius: 0.0,
                                    offset: const Offset(
                                      0.0,
                                      2.0,
                                    ),
                                  ),
                                ],
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                      ),
                                      height: 40,
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: themeData
                                                .colorScheme.secondaryContainer
                                                .withOpacity(0.6),
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                CupertinoIcons.chevron_down,
                                                size: 20,
                                                color: themeData
                                                    .colorScheme.secondary,
                                              ),
                                              Container(width: 8),
                                              Text(
                                                "Back",
                                                style: TextStyle(
                                                    color: themeData
                                                        .colorScheme.secondary,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 18),
                                              )
                                            ],
                                          ))),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InnerShadow(
                                shadows: [
                                  BoxShadow(
                                    color: themeData.colorScheme.secondary
                                        .withOpacity(.2),
                                    blurRadius: 3.0,
                                    spreadRadius: 0.0,
                                    offset: const Offset(
                                      0.0,
                                      2.0,
                                    ),
                                  ),
                                ],
                                child: Container(
                                    width: 116,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                    ),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: themeData
                                              .colorScheme.secondaryContainer
                                              .withOpacity(0.6),
                                        ),
                                        child: tabBar(
                                          children: {
                                            0: buildSegment(
                                                icon:
                                                    CupertinoIcons.music_note_2,
                                                number: 0),
                                            1: buildSegment(
                                                icon:
                                                    CupertinoIcons.list_bullet,
                                                number: 1),
                                          },
                                        ))),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    body: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          playerWidget(state),
                          const PlaylistWidget()
                        ])),
              );
            },
          ),
        ));
  }

  Widget playerWidget(ThemeState themeState) {
    final width = MediaQuery.sizeOf(context).width;
    return BlocBuilder<MusicCubit, MusicState>(
      builder: (context, state) {
        final isPlaying =
            state.musicControllerStatus is MusicControllerPlayingStatus;
        return StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) {
            final data = snapshot.data;
            if (data?.sequence.isEmpty ?? true) {
              return const SizedBox();
            }
            final metaData = data!.currentSource!.tag as MediaItem;
            return Column(
              children: [
                Container(
                  width: width,
                  height: width - 28,
                  padding: const EdgeInsets.only(bottom: 28, top: 0),
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: width - (isPlaying ? 60 : 120),
                      height: width - (isPlaying ? 60 : 120),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius:
                              BorderRadius.circular(isPlaying ? 16 : 24),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.3),
                                blurRadius: isPlaying ? 24 : 10,
                                offset: Offset(0, isPlaying ? 16 : 2),
                                spreadRadius: isPlaying ? 4 : 2),
                          ]),
                      child: SizedBox(
                        width: width - (isPlaying ? 60 : 120),
                        height: width - (isPlaying ? 60 : 120),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: DownLoadManager.isSongDownloaded(metaData.id)
                              ? DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: FileImage(
                                          File.fromUri(metaData.artUri!),
                                          scale: 1),
                                      centerSlice:
                                          const Rect.fromLTRB(1, 1, 1, 1),
                                    ),
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl: metaData.artUri.toString(),
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.music_note,
                                          size: 40,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    width: width - 60,
                    child: Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MarqueeWidget(
                            child: Text(
                              metaData.title,
                              maxLines: 1,
                              style: TextStyle(
                                  color: themeState.textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                          Text(
                            metaData.artist!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: themeState.textColor.withOpacity(0.8),
                                fontWeight: FontWeight.normal,
                                fontSize: 20),
                          )
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder<PositionData>(
                    stream: Rx.combineLatest3<Duration, Duration, Duration?,
                            PositionData>(
                        player.positionStream,
                        player.bufferedPositionStream,
                        player.durationStream,
                        (position, bufferedPosition, duration) => PositionData(
                            position,
                            bufferedPosition,
                            duration ?? Duration.zero)),
                    builder: (context, snapShot) {
                      final positionData = snapShot.data;
                      return PlayerProgressBar(
                        total: positionData?.duration ?? Duration.zero,
                        progress: positionData?.position ?? Duration.zero,
                        buffer: positionData?.bufferedPosition ?? Duration.zero,
                        onChanged: (value) {
                          player.seek(value);
                        },
                      );
                    }),
                const SizedBox(
                  height: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const LoopButton(),
                    const SizedBox(
                      width: 6,
                    ),
                    const PreviousButton(),
                    const SizedBox(
                      width: 10,
                    ),
                    StreamBuilder<PlayerState>(
                        stream: player.playerStateStream,
                        builder: (context, snapShot) {
                          final playerState = snapShot.data;
                          final processingState = playerState?.processingState;
                          isPlaying
                              ? playAnimationController.forward()
                              : playAnimationController.reverse();
                          return Container(
                            height: 80,
                            width: 80,
                            padding: const EdgeInsets.all(4),
                            child: MaterialButton(
                              onPressed: () {
                                _playPauseOnPressed(state);
                              },
                              color: isPlaying
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onPrimary,
                              elevation: isPlaying ? 4 : 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(62.0),
                              ),
                              child: AnimatedIcon(
                                icon: AnimatedIcons.play_pause,
                                progress: playAnimation,
                                size: 38,
                                color: isPlaying
                                    ? Theme.of(context).colorScheme.onSecondary
                                    : Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          );
                        }),
                    const SizedBox(
                      width: 10,
                    ),
                    const ForwardButton(),
                    const SizedBox(
                      width: 6,
                    ),
                    const ShuffleButton()
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }

  Widget tabBar({required Map<int, Widget> children}) {
    return Container(
      height: 40,
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 0, right: 0),
      padding: const EdgeInsets.all(0),
      child: CustomSlidingSegmentedControl(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        //thumbColor: Colors.white,
        thumbDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.secondary.withOpacity(.2),
              blurRadius: 1.0,
              spreadRadius: 1.0,
              offset: const Offset(
                0.0,
                1.0,
              ),
            ),
          ],
        ),
        height: 40,
        innerPadding: const EdgeInsets.all(4),
        initialValue: 0,
        children: children,
        controller: _segmentedController,
        onValueChanged: (value) {
          setState(() {
            page = value;
            _segmentedController.value = value;
            _tabController.animateTo(page);
          });
        },
      ),
    );
  }

  Widget buildSegment({required IconData icon, required int number}) {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(left: 4, right: 4, top: 0, bottom: 0),
      child: Center(
        child: Icon(
          icon,
          size: 22,
          color: page == number
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.secondary.withOpacity(0.7),
        ),
      ),
    );
  }
}
