// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:music_box/core/services/ext_storage.dart';
import 'package:music_box/features/music_feature/data/models/my_music_model.dart';
import 'package:music_box/features/music_feature/data/models/my_playlist_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:http/http.dart' as http;

abstract class IMusicRemoteDataSource {
  Future<List> fetchSongsList(String searchQuery);
  Future<List<MyMusicModel>> getMusicPlaylist(dynamic playListId);
  Future<List<dynamic>> getUserPlayLists();
  String addUserPlayList(String playListId);
  void removeUserPlayList(String playListId);
  Future<void> addUserLikedSong(dynamic songId);
  void removeUserLikedSong(dynamic songId);
  bool isSongAlreadyLiked(dynamic songId);
  Future<List<MyPlaylistModel>> getPlayLists([int? playListNum]);
  Future<List<MyPlaylistModel>> searchPlayList(String searchQuery);
  Future<List<AudioOnlyStreamInfo>> getStreamInfo(String songId);
  Stream<List<int>> getStreamClient(AudioOnlyStreamInfo streamInfo);
  Future<Map> getRandomSong();
  Future getSongsFromPlayList(dynamic playListId);
  Future<void> setActivePlayList(List<MyMusicModel> playList);
  Future getPlayListInfoForWidget(dynamic id);
  Future<String> getSongUrl(dynamic songId);
  Future getSongDetails(dynamic songIndex, dynamic songId);
  Future<List<SongModel>> getLocalSongs();
  Future<List<Map<String, int>>> getSkipSegments(String id);
}

class MusicRemoteDataSource extends IMusicRemoteDataSource {
  final yt = YoutubeExplode();
  final OnAudioQuery _audioQuery = OnAudioQuery();

  final random = Random();

  List<MyPlaylistModel> playlists = [];
  List userPlaylists = [];
  List userLikedSongsList = [];
  List<MyPlaylistModel> suggestedPlaylists = [];

  @override
  Future<List> fetchSongsList(String searchQuery) async {
    final List list = await yt.search.search(searchQuery);
    final searchedList = [
      // for (final s in list)
      //   Helper.returnSongLayout(
      //     0,
      //     s,
      //   )
    ];

    return searchedList;
  }

  @override
  Future<List<MyMusicModel>> getMusicPlaylist(dynamic playListId) async {
    final List<MyMusicModel> playlistSongs = [];
    // await musicLocalDataSource.getData() ?? [];
    if (playlistSongs.isEmpty) {
      var index = 0;
      await for (Video song in yt.playlists.getVideos(playListId)) {
        final music = MyMusicModel.fromSongModel(song, index);
        playlistSongs.add(music);
        // musicLocalDataSource.addOrUpdateData(music);
        index += 1;
      }
    }

    return playlistSongs;
  }

  @override
  Future<List<MyPlaylistModel>> getUserPlayLists() async {
    List<MyPlaylistModel> playlistsByUser = [];
    for (final playlistID in userPlaylists) {
      final plist = await yt.playlists.get(playlistID);
      playlistsByUser.add(MyPlaylistModel(
          ytid: plist.id.toString(),
          title: plist.title,
          subtitle: 'Just Updated',
          headerDesc: plist.description.length < 120
              ? plist.description
              : plist.description.substring(0, 120),
          view: 'playlist',
          image: '',
          list: []));
    }
    return playlistsByUser;
  }

  @override
  String addUserPlayList(String playlistId) {
    if (playlistId.length != 34) {
      return 'This is not a Youtube playlist ID';
    } else {
      userPlaylists.add(playlistId);
      // musicLocalDataSource.addOrUpdateData('user', 'playlists', userPlaylists);
      return '${"Added successfully"}!';
    }
  }

  @override
  void removeUserPlayList(String playListId) {
    userPlaylists.remove(playListId);
    // musicLocalDataSource.addOrUpdateData('user', 'playlists', userPlaylists);
  }

  @override
  Future<void> addUserLikedSong(dynamic songId) async {
    userLikedSongsList
        .add(await getSongDetails(userLikedSongsList.length, songId));
    // musicLocalDataSource.addOrUpdateData(
    //     'user', 'likedSongs', userLikedSongsList);
  }

  @override
  void removeUserLikedSong(dynamic songId) {
    userLikedSongsList.removeWhere((song) => song['ytid'] == songId);
    // musicLocalDataSource.addOrUpdateData(
    //     'user', 'likedSongs', userLikedSongsList);
  }

  @override
  bool isSongAlreadyLiked(dynamic songId) {
    return userLikedSongsList
        .where((song) => song['ytid'] == songId)
        .isNotEmpty;
  }

  @override
  Future<List<MyPlaylistModel>> getPlayLists([int? playListNum]) async {
    if (playlists.isEmpty) {
      var response = json.decode(
          await rootBundle.loadString('assets/db/playlists.db.json')) as List;
      playlists = response
          .map<MyPlaylistModel>(
              (playlist) => MyPlaylistModel.fromJson(playlist))
          .toList();
    }

    if (playListNum != null) {
      if (suggestedPlaylists.isEmpty) {
        suggestedPlaylists =
            (playlists.toList()..shuffle()).take(playListNum).toList();
      }
      return suggestedPlaylists;
    } else {
      return playlists;
    }
  }

  @override
  Future<List<MyPlaylistModel>> searchPlayList(String searchQuery) async {
    if (playlists.isEmpty) {
      var response = json.decode(
          await rootBundle.loadString('assets/db/playlists.db.json')) as List;
      playlists = response
          .map<MyPlaylistModel>(
              (playlist) => MyPlaylistModel.fromJson(playlist))
          .toList();
    }
    if (searchQuery.isEmpty) {
      return playlists;
    } else {
      return playlists
          .where(
            (playlist) => playlist.title!
                .toLowerCase()
                .contains(searchQuery.toLowerCase()),
          )
          .toList();
    }
  }

  @override
  Future<Map> getRandomSong() async {
    const playlistId = 'PLgzTt0k8mXzEk586ze4BjvDXR7c-TUSnx';
    final List playlistSongs = await getSongsFromPlayList(playlistId);

    return playlistSongs[random.nextInt(playlistSongs.length)];
  }

  @override
  Future getSongsFromPlayList(dynamic playListId) async {
    // final List playlistSongs = await musicLocalDataSource.getData(
    //         'cache', 'playlistSongs$playListId') ??
    final List playlistSongs = [];
    if (playlistSongs.isEmpty) {
      var index = 0;
      await for (final song in yt.playlists.getVideos(playListId)) {
        // playlistSongs.add(
        //   Helper.returnSongLayout(
        //     index,
        //     song,
        //   ),
        // );
        index += 1;
      }
      // musicLocalDataSource.addOrUpdateData(
      //     'cache', 'playlistSongs$playListId', playlistSongs);
    }

    return playlistSongs;
  }

  @override
  Future<void> setActivePlayList(List<MyMusicModel> playList) async {
    // activePlaylist = playList;
    // await enqueueSongList(activePlaylist);
  }

  @override
  Future getPlayListInfoForWidget(dynamic id) async {
    var searchPlaylist =
        playlists.where((playlist) => playlist.ytid == id).toList();
    var isUserPlaylist = false;

    if (searchPlaylist.isEmpty) {
      final usPlaylists = await getUserPlayLists();
      searchPlaylist =
          usPlaylists.where((playlist) => playlist.ytid == id).toList();
      isUserPlaylist = true;
    }

    final playlist = searchPlaylist[0];

    if (playlist.list!.isEmpty) {
      searchPlaylist[searchPlaylist.indexOf(playlist)].list =
          await getSongsFromPlayList(playlist.ytid);
      if (!isUserPlaylist) {
        playlists[playlists.indexOf(playlist)].list =
            searchPlaylist[searchPlaylist.indexOf(playlist)].list;
      }
    }

    return playlist;
  }

  @override
  Future<String> getSongUrl(dynamic songId) async {
    final manifest = await yt.videos.streamsClient.getManifest(songId);

    return manifest.audioOnly.withHighestBitrate().url.toString();
  }

  @override
  Future getSongDetails(dynamic songIndex, dynamic songId) async {
    final song = await yt.videos.get(songId);
    // return Helper.returnSongLayout(
    //   songIndex,
    //   song,
    // );
  }

  @override
  Future<List<SongModel>> getLocalSongs() async {
    var localSongs = <SongModel>[];
    if (await ExtStorageProvider.requestPermission(Permission.storage)) {
      localSongs = await _audioQuery.querySongs(
        path: await ExtStorageProvider.getExtStorage(dirName: 'Music'),
      );
    }

    return localSongs;
  }

  @override
  Future<List<Map<String, int>>> getSkipSegments(String id) async {
    try {
      final res = await http.get(
        Uri(
          scheme: 'https',
          host: 'sponsor.ajay.app',
          path: '/api/skipSegments',
          queryParameters: {
            'videoID': id,
            'category': [
              'sponsor',
              'selfpromo',
              'interaction',
              'intro',
              'outro',
              'music_offtopic'
            ],
            'actionType': 'skip'
          },
        ),
      );
      if (res.body != 'Not Found') {
        final data = jsonDecode(res.body);
        final segments = data.map((obj) {
          return Map.castFrom<String, dynamic, String, int>({
            'start': obj['segment'].first.toInt(),
            'end': obj['segment'].last.toInt(),
          });
        }).toList();
        return List.castFrom<dynamic, Map<String, int>>(segments);
      } else {
        return [];
      }
    } catch (e, stack) {
      print('$e $stack');
      return [];
    }
  }

  @override
  Future<List<AudioOnlyStreamInfo>> getStreamInfo(String songId) async {
    final StreamManifest manifest =
        await yt.videos.streamsClient.getManifest(VideoId(songId.toString()));
    final List<AudioOnlyStreamInfo> sortedStreamInfo = manifest.audioOnly
        .toList()
      ..sort((a, b) => a.bitrate.compareTo(b.bitrate));
    return sortedStreamInfo;
  }

  @override
  Stream<List<int>> getStreamClient(AudioOnlyStreamInfo streamInfo) {
    return yt.videos.streamsClient.get(streamInfo);
  }
}
