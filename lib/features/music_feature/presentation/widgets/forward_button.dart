import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_box/core/services/audio_manger.dart';
import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_cubit.dart';
import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_state.dart';

class ForwardButton extends StatelessWidget {
  const ForwardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicCubit, MusicState>(
      builder: (context, state) {
        return StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapShot) {
            final data = snapShot.data;
            if (data?.sequence.isEmpty ?? true) {
              return const SizedBox();
            }
            final isLastSong = state.currentQueue.isEmpty ||
                state.currentQueue.last.id == data!.currentSource!.tag.id;
            return SizedBox(
                height: 60,
                width: 60,
                child: IconButton(
                  splashColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.all(12),
                  onPressed: () {
                    !isLastSong ? context.read<MusicCubit>().next() : null;
                  },
                  icon: Icon(
                    CupertinoIcons.forward_fill,
                    size: 28,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(!isLastSong ? 1.0 : 0.3),
                  ),
                ));
          },
        );
      },
    );
  }
}
