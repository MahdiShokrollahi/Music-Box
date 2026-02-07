import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_box/core/params/file_path_param.dart';
import 'package:music_box/core/services/ext_storage.dart';
import 'package:music_box/core/utils/constants.dart';
import 'package:music_box/features/music_feature/data/models/my_music_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownLoadManager {
  static late String musicPath;
  static late String imagePath;

  static final box = Hive.box<MyMusicModel>(Constants.downloadBox);
  static ValueListenable<Box<MyMusicModel>> get listenable => box.listenable();
  static bool isSongDownloaded(String ytId) {
    return box.containsKey(ytId);
  }

  static Future<FilePathParam> createFile(MyMusicModel song) async {
    Constants.logger.i('Preparing download for ${song.title})');
    Constants.logger.i('Requesting storage permission');
    PermissionStatus status = await Permission.storage.status;

    if (status.isDenied) {
      Constants.logger.i('Request denied');
      await [
        Permission.storage,
        Permission.accessMediaLocation,
        Permission.mediaLibrary
      ].request();
    }

    status = await Permission.storage.status;

    if (status.isPermanentlyDenied) {
      Constants.logger.i('Request permanently denied');
      await openAppSettings();
    }

    var fileName =
        '${song.title!.replaceAll(r'\', '').replaceAll('/', '').replaceAll('*', '').replaceAll('?', '').replaceAll('"', '').replaceAll('<', '').replaceAll('>', '').replaceAll('|', '')}.mp3';

    var dlPath = await ExtStorageProvider.getExtStorage(dirName: 'Music');
    dlPath = '$dlPath/MusicBox';
    if (!await Directory(dlPath).exists()) {
      Constants.logger.i('Creating MusicBox folder');
      await Directory(dlPath).create(recursive: true);
    }

    final bool exists = await File('$dlPath/$fileName').exists();

    if (exists) {
      Constants.logger.i('File already exists');
      fileName = fileName.replaceAll('.mp3', '(1).mp3');
    }
    final appPath = (await getDownloadsDirectory())!.path;

    final artName = fileName.replaceAll('.mp3', '.jpg');

    try {
      await File('$dlPath/$fileName')
          .create(recursive: true)
          .then((value) => musicPath = value.path);
      Constants.logger.i('Creating audio file $dlPath/$fileName');

      await File('$appPath/$artName')
          .create(recursive: true)
          .then((value) => imagePath = value.path);
      Constants.logger.i('Creating image file $appPath/$artName');
    } catch (e) {
      Constants.logger
          .i('Error creating files, requesting additional permission');
      PermissionStatus status = await Permission.manageExternalStorage.status;

      if (status.isDenied) {
        Constants.logger.i(
            'ManageExternalStorage permission is denied, requesting permission');
        await [
          Permission.manageExternalStorage,
        ].request();
      }

      status = await Permission.manageExternalStorage.status;

      if (status.isPermanentlyDenied) {
        Constants.logger.i(
          'ManageExternalStorage Request is permanently denied, opening settings',
        );
        await openAppSettings();
      }
      Constants.logger.i('Retrying to create audio file');
      await File('$dlPath/$artName')
          .create(recursive: true)
          .then((value) => musicPath = value.path);

      Constants.logger.i('Retrying to create image file');
      await File('$appPath/$artName')
          .create(recursive: true)
          .then((value) => imagePath = value.path);
    }
    return FilePathParam(musicPath, imagePath);
  }
}
