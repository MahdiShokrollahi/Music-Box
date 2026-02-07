import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_box/core/services/service_locator.dart';
import 'package:music_box/features/music_feature/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:music_box/features/music_feature/presentation/cubits/home_cubit/songs_data_status.dart';
import 'package:music_box/features/music_feature/presentation/screens/playlist_screen.dart';
import 'package:music_box/features/music_feature/presentation/widgets/song_item.dart';
import 'package:shimmer/shimmer.dart';

import '../cubits/home_cubit/palylists_data_status.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: BlocProvider(
        create: (context) => HomeCubit(locator())
          ..getPlaylists()
          ..getSongs(),
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                'MusicBox',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 35,
                  fontWeight: FontWeight.w800,
                ),
              ),
              elevation: 0,
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: height / 55, bottom: 32, left: 20, right: 20),
                    child: const Text(
                      'Suggested playlists',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
                    if (state.playlistsDataStatus
                        is SuggestedPlaylistsDataLoading) {
                      return SizedBox(
                        height: 230,
                        child: ListView.builder(
                            itemCount: 10,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.blueGrey.shade800,
                                highlightColor: Colors.grey,
                                child: Container(
                                  height: height / 4.15,
                                  width: width / 1.9,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                    if (state.playlistsDataStatus
                        is SuggestedPlaylistsDataCompleted) {
                      SuggestedPlaylistsDataCompleted playlistsDataCompleted =
                          state.playlistsDataStatus
                              as SuggestedPlaylistsDataCompleted;
                      var suggestedPlaylists =
                          playlistsDataCompleted.suggestedPlaylists;
                      return SizedBox(
                        height: 230,
                        child: ListView.builder(
                            itemCount: suggestedPlaylists.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var playlist = suggestedPlaylists[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PlaylistScreen(
                                                playlist: playlist,
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: SizedBox(
                                    height: height / 4.15,
                                    width: width / 1.9,
                                    child: CachedNetworkImage(
                                      imageUrl: playlist.image!,
                                      imageBuilder: (context, imageProvider) {
                                        return DecoratedBox(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover)));
                                      },
                                      errorWidget: (context, url, error) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                                      placeholder: (context, url) {
                                        return Container(
                                          height: height / 4.15,
                                          width: width / 1.9,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color.fromARGB(
                                                255, 96, 94, 94),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                    if (state.playlistsDataStatus
                        is SuggestedPlaylistsDataError) {
                      SuggestedPlaylistsDataError playlistsDataError = state
                          .playlistsDataStatus as SuggestedPlaylistsDataError;
                      var error = playlistsDataError.error;
                      return Center(
                        child: Text(error),
                      );
                    }
                    return Container();
                  })
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 20,
                      bottom: 10,
                      left: 20,
                      right: 20,
                    ),
                    child: const Text(
                      'Recommended for you',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
                    if (state.songsDataStatus is SongsDataLoading) {
                      return ListView.builder(
                          itemCount: 10,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 30),
                          shrinkWrap: true,
                          itemBuilder: (context, state) {
                            return Shimmer.fromColors(
                              baseColor: Colors.blueGrey.shade800,
                              highlightColor: Colors.grey,
                              child: Container(
                                height: 70,
                                margin: const EdgeInsets.only(
                                    top: 10, left: 12, right: 12),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 87, 86, 86),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                              ),
                            );
                          });
                    }
                    if (state.songsDataStatus is SongsDataCompleted) {
                      SongsDataCompleted songsDataCompleted =
                          state.songsDataStatus as SongsDataCompleted;
                      var songs = songsDataCompleted.songs.sublist(0, 10);
                      return ListView.builder(
                        itemCount: songs.length,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 30),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var song = songs[index];
                          return SongItem(
                            playlist: songs,
                            index: index,
                            song: song,
                          );
                        },
                      );
                    }
                    if (state.songsDataStatus is SongsDataError) {
                      SongsDataError songsDataError =
                          state.songsDataStatus as SongsDataError;
                      var error = songsDataError.error;
                      return Center(
                        child: Text(
                          error,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return Container();
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
