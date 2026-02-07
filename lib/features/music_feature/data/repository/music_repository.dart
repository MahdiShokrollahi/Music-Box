import 'package:dartz/dartz.dart';
import 'package:music_box/features/music_feature/data/data_source/remote/music_remote_data_source.dart';
import 'package:music_box/features/music_feature/data/models/my_music_model.dart';
import 'package:music_box/features/music_feature/data/models/my_playlist_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

abstract class IMusicRepository {
  Future<List> fetchSongsList(String searchQuery);
  Future<Either<String, List<MyMusicModel>>> getMusicPlaylist(
      dynamic playListId);
  Future<List<dynamic>> getUserPlayLists();
  String addUserPlayList(String playListId);
  void removeUserPlayList(String playListId);
  Future<void> addUserLikedSong(dynamic songId);
  void removeUserLikedSong(dynamic songId);
  bool isSongAlreadyLiked(dynamic songId);
  Future<Either<String, List<MyPlaylistModel>>> getPlayLists(
      [int? playListNum]);
  Future<Either<String, List<MyPlaylistModel>>> searchPlayList(
      String searchQuery);
  Future<Map> getRandomSong();
  Future getSongsFromPlayList(dynamic playListId);
  Future<void> setActivePlayList(List<MyMusicModel> playList);
  Future getPlayListInfoForWidget(dynamic id);
  Future<String> getSongUrl(dynamic songId);
  Future getSongDetails(dynamic songIndex, dynamic songId);
  Future<List<SongModel>> getLocalSongs();
  Future<List<Map<String, int>>> getSkipSegments(String id);
  Future<List<AudioOnlyStreamInfo>> getStreamInfo(String songId);
  Stream<List<int>> getStreamClient(AudioOnlyStreamInfo streamInfo);
}

class MusicRepository extends IMusicRepository {
  final IMusicRemoteDataSource dataSource;

  MusicRepository(this.dataSource);
  @override
  Future<void> addUserLikedSong(songId) {
    // TODO: implement addUserLikedSong
    throw UnimplementedError();
  }

  @override
  String addUserPlayList(String playListId) {
    // TODO: implement addUserPlayList
    throw UnimplementedError();
  }

  @override
  Future<List> fetchSongsList(String searchQuery) {
    // TODO: implement fetchSongsList
    throw UnimplementedError();
  }

  @override
  Future<Either<String, List<MyMusicModel>>> getMusicPlaylist(
      playListId) async {
    try {
      final songs = await dataSource.getMusicPlaylist(playListId);
      return right(songs);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<List<SongModel>> getLocalSongs() {
    // TODO: implement getLocalSongs
    throw UnimplementedError();
  }

  @override
  Future getPlayListInfoForWidget(id) {
    // TODO: implement getPlayListInfoForWidget
    throw UnimplementedError();
  }

  @override
  Future<Either<String, List<MyPlaylistModel>>> getPlayLists(
      [int? playListNum]) async {
    try {
      final playlist = await dataSource.getPlayLists(playListNum);
      return right(playlist);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Map> getRandomSong() {
    // TODO: implement getRandomSong
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, int>>> getSkipSegments(String id) {
    // TODO: implement getSkipSegments
    throw UnimplementedError();
  }

  @override
  Future<String> getSongUrl(songId) async {
    final songUrl = await dataSource.getSongUrl(songId);
    return songUrl;
  }

  @override
  Future getSongDetails(songIndex, songId) {
    // TODO: implement getSongDetails
    throw UnimplementedError();
  }

  @override
  Future getSongsFromPlayList(playListId) {
    // TODO: implement getSongsFromPlayList
    throw UnimplementedError();
  }

  @override
  Future<List> getUserPlayLists() {
    // TODO: implement getUserPlayLists
    throw UnimplementedError();
  }

  @override
  bool isSongAlreadyLiked(songId) {
    // TODO: implement isSongAlreadyLiked
    throw UnimplementedError();
  }

  @override
  void removeUserLikedSong(songId) {
    // TODO: implement removeUserLikedSong
  }

  @override
  void removeUserPlayList(String playListId) {
    // TODO: implement removeUserPlayList
  }

  @override
  Future<Either<String, List<MyPlaylistModel>>> searchPlayList(
      String searchQuery) async {
    try {
      final searchPlaylist = await dataSource.searchPlayList(searchQuery);
      return right(searchPlaylist);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<void> setActivePlayList(List<MyMusicModel> playList) async {
    try {
      await dataSource.setActivePlayList(playList);
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<AudioOnlyStreamInfo>> getStreamInfo(String songId) async {
    try {
      final streamInfo = await dataSource.getStreamInfo(songId);
      return streamInfo;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Stream<List<int>> getStreamClient(AudioOnlyStreamInfo streamInfo) {
    try {
      final result = dataSource.getStreamClient(streamInfo);
      return result;
    } catch (e) {
      throw Exception();
    }
  }
}
