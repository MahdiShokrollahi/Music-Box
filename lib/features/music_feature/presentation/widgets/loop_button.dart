import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_cubit.dart';
import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_state.dart';

class LoopButton extends StatelessWidget {
  const LoopButton({super.key});
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return BlocBuilder<MusicCubit, MusicState>(
      builder: (context, state) {
        return SizedBox(
          height: 34,
          width: 34,
          child: IconButton(
              onPressed: () {
                context.read<MusicCubit>().toggleLoopMode();
              },
              icon: Icon(
                CupertinoIcons.repeat,
                size: 22,
                color: state.isLoopModeEnabled
                    ? Colors.orange
                    : themeData.colorScheme.secondary,
              )),
        );
      },
    );
  }
}
