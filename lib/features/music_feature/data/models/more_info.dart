import 'package:hive/hive.dart';
part 'more_info.g.dart';

@HiveType(typeId: 1)
class MoreInfo extends HiveObject {
  @HiveField(0)
  String? primaryArtists;
  @HiveField(1)
  String? singers;

  MoreInfo({this.primaryArtists, this.singers});

  MoreInfo.fromJson(Map<String, dynamic> json) {
    primaryArtists = json["primary_artists"];
    singers = json["singers"];
  }
}
