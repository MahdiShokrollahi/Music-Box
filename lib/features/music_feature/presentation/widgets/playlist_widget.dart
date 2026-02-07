import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_cubit.dart';
import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_state.dart';
import 'package:music_box/features/music_feature/presentation/widgets/shuffle_button.dart';

class PlaylistWidget extends StatelessWidget {
  const PlaylistWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Stack(
      children: [
        BlocBuilder<MusicCubit, MusicState>(
          builder: (context, state) {
            var currentQueue = state.currentQueue;
            return ReorderableListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: currentQueue.length,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
              onReorder: (int oldIndex, int newIndex) {
                context
                    .read<MusicCubit>()
                    .onReorder(oldIndex: oldIndex, newIndex: newIndex);
              },
              itemBuilder: (context, index) {
                return Container(
                  key: ValueKey(currentQueue[index]),
                  margin: (index != state.currentSongIndex)
                      ? const EdgeInsets.only(
                          left: 8, right: 8, bottom: 4, top: 4)
                      : const EdgeInsets.only(
                          left: 0, right: 0, bottom: 8, top: 4),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: index == state.currentSongIndex
                              ? themeData.colorScheme.primary.withOpacity(.2)
                              : Colors.transparent,
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                          offset: const Offset(
                            0.0,
                            5.0,
                          ),
                        ),
                      ],
                      color: index == state.currentSongIndex
                          ? themeData.colorScheme.onSecondary.withOpacity(1.0)
                          : themeData.colorScheme.secondaryContainer
                              .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16)),
                  child: Dismissible(
                      key: ValueKey(currentQueue[index]),
                      background: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.redAccent,
                        ),
                        alignment: Alignment.centerRight,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                      onDismissed: (direction) {
                        context.read<MusicCubit>().remove(index: index);
                      },
                      child: GestureDetector(
                          onTap: () {
                            context.read<MusicCubit>().play(index: index);
                          },
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 80),
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 12, bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    width: 50,
                                    height: 50,
                                    color: Colors.transparent,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Stack(
                                        children: [
                                          ReorderableDragStartListener(
                                            index: index,
                                            child: CachedNetworkImage(
                                                imageUrl:
                                                    '${currentQueue[index].artUri}',
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover),
                                          ),
                                          index == state.currentSongIndex
                                              ? BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 2, sigmaY: 2),
                                                  child: Container(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Image.asset(
                                                          "assets/images/ezgif.gif")),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    )),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentQueue[index].title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: TextStyle(
                                            color:
                                                themeData.colorScheme.secondary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        "${currentQueue[index].artist}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: (themeData
                                                    .colorScheme.secondary)
                                                .withOpacity(0.8),
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ))),
                );
              },
            );
          },
        ),
        const Positioned(
            bottom: 60,
            right: 15,
            child: SizedBox(
                height: 60,
                width: 60,
                child: FittedBox(child: ShuffleButton()))),
      ],
    );
  }
}
