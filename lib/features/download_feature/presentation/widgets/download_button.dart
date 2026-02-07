import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_box/core/services/downlaod_manager.dart';
import 'package:music_box/features/download_feature/presentation/cubits/download_cubit/download_cubit.dart';
import 'package:music_box/core/services/service_locator.dart';
import 'package:music_box/features/music_feature/data/models/my_music_model.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({super.key, required this.song});
  final MyMusicModel song;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DownloadCubit(locator(), locator()),
      child:
          BlocBuilder<DownloadCubit, DownloadState>(builder: (context, state) {
        return ValueListenableBuilder(
            valueListenable: DownLoadManager.listenable,
            builder: (context, box, child) {
              return box.containsKey(song.ytid)
                  ? IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.download_done_rounded,
                      ),
                      iconSize: 24,
                      color: Colors.greenAccent,
                    )
                  : state.progress == 0.0
                      ? IconButton(
                          onPressed: () {
                            context.read<DownloadCubit>().downloadSong(song);
                          },
                          icon: const Icon(Icons.download_rounded),
                          iconSize: 24,
                          color: Colors.red,
                        )
                      : Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            CircularProgressIndicator(
                              value:
                                  state.progress == 1.0 ? null : state.progress,
                            ),
                            Text(
                              state.progress == null
                                  ? '0%'
                                  : '${(100 * state.progress!).round()}%',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            )
                          ],
                        );
            });
      }),
    );
  }
}
