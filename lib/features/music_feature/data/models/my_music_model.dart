import 'package:hive/hive.dart';
import 'package:music_box/core/helper/formatter.dart';
import 'package:music_box/features/music_feature/data/models/more_info.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
part 'my_music_model.g.dart';

@HiveType(typeId: 0)
class MyMusicModel extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? ytid;
  @HiveField(2)
  String? title;
  @HiveField(3)
  String? image;
  @HiveField(4)
  String? lowResImage;
  @HiveField(5)
  String? highResImage;
  @HiveField(6)
  String? album;
  @HiveField(7)
  String? type;
  @HiveField(8)
  MoreInfo? moreInfo;
  @HiveField(9)
  String? songUrl;
  @HiveField(10)
  String? duration;

  MyMusicModel(
      {this.id,
      this.ytid,
      this.title,
      this.image,
      this.lowResImage,
      this.highResImage,
      this.album,
      this.type,
      this.moreInfo,
      this.songUrl,
      this.duration});

  MyMusicModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    ytid = json["ytid"];
    title = json["title"];
    image = json["image"];
    lowResImage = json["lowResImage"];
    highResImage = json["highResImage"];
    album = json["album"];
    type = json["type"];
    moreInfo =
        json["more_info"] == null ? null : MoreInfo.fromJson(json["more_info"]);
    songUrl = json["songUrl"];
    duration = json["duration"];
  }

  factory MyMusicModel.fromSongModel(Video song, int index) {
    return MyMusicModel(
        id: index,
        ytid: song.id.toString(),
        title: Helper.formatSongTitle(
                song.title.split('-')[song.title.split('-').length - 1])
            .split('(')[0]
            .replaceAll('&quot;', '"')
            .replaceAll('&amp;', '&'),
        image: song.thumbnails.standardResUrl,
        lowResImage: song.thumbnails.lowResUrl,
        highResImage: song.thumbnails.maxResUrl,
        album: '',
        type: 'song',
        moreInfo: MoreInfo(
            primaryArtists: song.title.split('-')[0],
            singers: song.title.split('-')[0]),
        songUrl: '',
        duration: song.duration.toString());
  }
}
