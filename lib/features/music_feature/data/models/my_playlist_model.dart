import 'package:music_box/features/music_feature/data/models/my_music_model.dart';


class MyPlaylistModel {

  String? ytid;


  String? title;


  String? subtitle;


  String? headerDesc;


  String? view;


  String? time;


  String? image;


  List<MyMusicModel>? list;


  MyPlaylistModel(

      {this.ytid,

      this.title,

      this.subtitle,

      this.headerDesc,

      this.view,

      this.time,

      this.image,

      this.list});


  MyPlaylistModel.fromJson(Map<String, dynamic> json) {

    ytid = json["ytid"];


    title = json["title"];


    subtitle = json["subtitle"];


    headerDesc = json["header_desc"];


    view = json["view"];


    time = json["time"];


    image = json["image"];


    list = json["list"] == null

        ? null

        : (json["list"] as List).map((e) => MyMusicModel.fromJson(e)).toList();

  }

}

