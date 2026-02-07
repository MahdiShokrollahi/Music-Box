import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_cubit.dart';

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return SizedBox(
      height: 34,
      width: 34,
      child: IconButton(
          padding: const EdgeInsets.all(6),
          onPressed: () {
            context.read<MusicCubit>().shuffleQueue();
          },
          icon: const Icon(
            CupertinoIcons.shuffle,
            size: 22,
            color: Colors.white,
          )),
    );
  }
}
