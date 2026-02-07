import 'package:hive/hive.dart';
import 'package:music_box/features/music_feature/data/models/my_music_model.dart';

abstract class IDownloadDataSource {
  addSong(MyMusicModel song);
  deleteSong(MyMusicModel song);
  List<MyMusicModel> getSongs();
  MyMusicModel getSongDownloadById(String ytId);
}

class DownloadDataSource extends IDownloadDataSource {
  final Box<MyMusicModel> box;
  DownloadDataSource(this.box);
  @override
  List<MyMusicModel> getSongs() {
    return box.values.toList();
  }

  @override
  deleteSong(MyMusicModel song) {
    box.delete(song.id);
  }

  @override
  MyMusicModel getSongDownloadById(String ytId) {
    return box.get(ytId)!;
  }

  @override
  addSong(MyMusicModel song) {
    box.put(song.ytid, song);
  }
}
