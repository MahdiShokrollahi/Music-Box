import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_box/core/services/service_locator.dart';
import 'package:music_box/features/music_feature/data/models/my_playlist_model.dart';
import 'package:music_box/features/music_feature/presentation/cubits/playlist_cubit/music_playlist_data_status.dart';
import 'package:music_box/features/music_feature/presentation/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_box/features/music_feature/presentation/widgets/sliver_playlist_appbar.dart';
import 'package:music_box/features/music_feature/presentation/widgets/song_item.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key, required this.playlist});
  final MyPlaylistModel playlist;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: BlocProvider(
        create: (context) =>
            PlaylistCubit(locator())..getMusicPlaylist(playlist.ytid!),
        child: BlocBuilder<PlaylistCubit, PlaylistState>(
            builder: (context, state) {
          if (state.musicPlaylistDataStatus is MusicPlaylistDataLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.musicPlaylistDataStatus is MusicPlaylistDataCompleted) {
            MusicPlaylistDataCompleted musicPlaylistDataCompleted =
                state.musicPlaylistDataStatus as MusicPlaylistDataCompleted;
            final songs = musicPlaylistDataCompleted.songs;
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  delegate:
                      SliverPlaylistAppBar(playlist: playlist, songs: songs),
                  pinned: true,
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 30),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (context, index) => SongItem(
                              song: songs[index],
                              playlist: songs,
                              index: index),
                          childCount: songs.length)),
                )
              ],
            );
          }
          if (state.musicPlaylistDataStatus is MusicPlaylistDataError) {
            MusicPlaylistDataError musicPlaylistDataError =
                state.musicPlaylistDataStatus as MusicPlaylistDataError;
            return Center(
              child: Text(musicPlaylistDataError.error),
            );
          }
          return Container();
        }),
      ),
    );
  }
}
