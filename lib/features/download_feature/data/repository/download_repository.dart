import 'package:dartz/dartz.dart';
import 'package:music_box/features/download_feature/data/data_source/download_data_source.dart';
import 'package:music_box/features/music_feature/data/models/my_music_model.dart';

abstract class IDownloadRepository {
  addSong(MyMusicModel song);
  Either<String, List<MyMusicModel>> getSongs();
  deleteSong(MyMusicModel song);
  MyMusicModel getSongDownloadById(String ytId);
}

class DownloadRepository extends IDownloadRepository {
  final IDownloadDataSource _dataSource;

  DownloadRepository(this._dataSource);
  @override
  Either<String, List<MyMusicModel>> getSongs() {
    try {
      final songModel = _dataSource.getSongs();
      return right(songModel);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  deleteSong(MyMusicModel song) {
    try {
      _dataSource.deleteSong(song);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  MyMusicModel getSongDownloadById(String ytId) {
    return _dataSource.getSongDownloadById(ytId);
  }

  @override
  addSong(MyMusicModel song) {
    _dataSource.addSong(song);
  }
}
