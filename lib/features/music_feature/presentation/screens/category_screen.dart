import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_box/core/services/service_locator.dart';
import 'package:music_box/features/music_feature/presentation/cubits/playlist_cubit/playlist_cubit.dart';
import 'package:music_box/features/music_feature/presentation/cubits/playlist_cubit/playlists_data_status.dart';
import 'package:music_box/features/music_feature/presentation/screens/playlist_screen.dart';
import 'package:shimmer/shimmer.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _inputNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return BlocProvider(
      create: (context) => PlaylistCubit(locator())..loadPlaylists(),
      child: Builder(builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 20,
                    left: 12,
                    right: 12,
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _inputNode,
                    onSubmitted: (value) {
                      context
                          .read<PlaylistCubit>()
                          .loadPlaylists(searchQuery: value);
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    cursorColor: Colors.green[50],
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                          borderSide: BorderSide(color: Colors.grey.shade800)),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.red,
                        ),
                        color: Colors.red,
                        onPressed: () {
                          context.read<PlaylistCubit>().loadPlaylists(
                              searchQuery: _searchController.text);
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                      border: InputBorder.none,
                      hintText: 'search...',
                      hintStyle: const TextStyle(
                        color: Colors.red,
                      ),
                      contentPadding: const EdgeInsets.only(
                        left: 18,
                        right: 20,
                        top: 14,
                        bottom: 14,
                      ),
                    ),
                  )),
              BlocBuilder<PlaylistCubit, PlaylistState>(
                builder: (context, state) {
                  if (state.searchPlaylistsDataStatus
                      is SearchPlaylistsDataLoading) {
                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: 10,
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                          bottom: 20,
                        ),
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade800,
                            highlightColor: Colors.white,
                            child: Container(
                              width: width * 0.4,
                              height: height * 0.18,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                            ),
                          );
                        });
                  }
                  if (state.searchPlaylistsDataStatus
                      is SearchPlaylistsDataCompleted) {
                    SearchPlaylistsDataCompleted playlistsDataCompleted =
                        state.searchPlaylistsDataStatus
                            as SearchPlaylistsDataCompleted;
                    final playlists = playlistsDataCompleted.playlists;
                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: playlists.length,
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                          bottom: 20,
                        ),
                        itemBuilder: (context, index) {
                          var playlist = playlists[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PlaylistScreen(
                                        playlist: playlist,
                                      )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: SizedBox(
                                width: width * 0.4,
                                height: height * 0.18,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: playlist.image != ''
                                      ? CachedNetworkImage(
                                          imageUrl: playlist.image!,
                                          width: width * 0.4,
                                          height: height * 0.18,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) {
                                            return Shimmer.fromColors(
                                                baseColor: Colors.grey.shade800,
                                                highlightColor: Colors.white,
                                                child: Container(
                                                  width: width * 0.4,
                                                  height: height * 0.18,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15))),
                                                ));
                                          },
                                          errorWidget: (context, url, error) {
                                            return SizedBox(
                                                width: width * 0.4,
                                                height: height * 0.18,
                                                child: const Icon(
                                                  Icons.music_note_outlined,
                                                  size: 30,
                                                  color: Colors.red,
                                                ));
                                          },
                                        )
                                      : Container(
                                          width: 200,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey,
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                const Icon(
                                                  Icons.music_note_outlined,
                                                  size: 30,
                                                  color: Colors.red,
                                                ),
                                                Text(
                                                  playlist.title!,
                                                  style: const TextStyle(
                                                      color: Colors.red),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          );
                        });
                  }
                  if (state.searchPlaylistsDataStatus
                      is SearchPlaylistsDataError) {
                    SearchPlaylistsDataError playlistsDataError = state
                        .searchPlaylistsDataStatus as SearchPlaylistsDataError;
                    return Center(
                      child: Text(
                        playlistsDataError.error,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
        );
      }),
    );
    ;
  }
}
