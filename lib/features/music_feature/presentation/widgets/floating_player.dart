import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_cubit.dart';
import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_state.dart';
import 'package:music_box/features/music_feature/presentation/widgets/floating_music_controller.dart';
import 'package:music_box/features/music_feature/presentation/widgets/music_progress_bar.dart';

class FloatingPlayer extends StatelessWidget {
  const FloatingPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicCubit, MusicState>(
      builder: (context, state) {
        bool isShowPlayer =
            state.musicControllerStatus is MusicControllerPlayingStatus ||
                state.musicControllerStatus is MusicControllerPauseStatus;
        return isShowPlayer
            ? Dismissible(
                key: ValueKey(state.currentQueue),
                onDismissed: (direction) {
                  context.read<MusicCubit>().stop();
                },
                child: Column(
                  children: [
                    const MusicProgressBar(),
                    FloatingMusicController(state)
                  ],
                ))
            : Container();
      },
    );
  }
}
