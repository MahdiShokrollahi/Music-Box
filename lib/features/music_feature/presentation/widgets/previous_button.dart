import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_box/core/services/audio_manger.dart';
import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_cubit.dart';
import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_state.dart';

class PreviousButton extends StatelessWidget {
  const PreviousButton({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicCubit, MusicState>(
      builder: (context, state) {
        return StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) {
            final data = snapshot.data;
            if (data?.sequence.isEmpty ?? true) {
              return const SizedBox();
            }
            final isFirstSong = state.currentQueue.isEmpty ||
                state.currentQueue.first.id == data!.currentSource!.tag.id;
            return SizedBox(
              height: 60,
              width: 60,
              child: IconButton(
                onPressed: () {
                  !isFirstSong ? context.read<MusicCubit>().previous() : null;
                },
                icon: Icon(
                  CupertinoIcons.backward_fill,
                  size: 28,
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withOpacity(!isFirstSong ? 1.0 : 0.3),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
