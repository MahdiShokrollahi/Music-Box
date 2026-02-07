import 'dart:io';

import 'package:audiotagger/audiotagger.dart';

import 'package:audiotagger/models/tag.dart';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import 'package:flutter/foundation.dart';
import 'package:music_box/core/helper/flutter_toast.dart';
import 'package:music_box/core/services/downlaod_manager.dart';
import 'package:music_box/core/utils/constants.dart';

import 'package:music_box/features/download_feature/data/repository/download_repository.dart';

import 'package:music_box/features/music_feature/data/models/more_info.dart';

import 'package:music_box/features/music_feature/data/models/my_music_model.dart';

import 'package:music_box/features/music_feature/data/repository/music_repository.dart';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

part 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  final IMusicRepository musicRepository;

  final IDownloadRepository downloadRepository;

  final yt = YoutubeExplode();

  DownloadCubit(this.musicRepository, this.downloadRepository)
      : super(DownloadState(progress: 0.0));

  Future<void> downloadSong(MyMusicModel song) async {
    List<int> bytes = [];
    int total = 0;
    int received = 0;
    double? progress;
    Stream<List<int>> stream;

    final filePathParam = await DownLoadManager.createFile(song);
    emit(state.copyWith(progress: null));
    showToast('download started');

    final AudioOnlyStreamInfo streamInfo =
        (await musicRepository.getStreamInfo(song.ytid!)).last;

    total = streamInfo.size.totalBytes;

    stream = musicRepository.getStreamClient(streamInfo);
    Constants.logger.i('Client connected, Starting download');
    stream.listen((value) {
      bytes.addAll(value);
      try {
        received += value.length;

        progress = received / total;

        emit(state.copyWith(progress: progress));
      } catch (e) {
        Constants.logger.e('Error in download: $e');
        showToast(e.toString());
      }
    }).onDone(() async {
      Constants.logger.i('Download completed, modifying file');
      final file = File(filePathParam.musicPath);
      await file.writeAsBytes(bytes);
      Constants.logger.i('File modified, downloading image');
      final client = HttpClient();

      final HttpClientRequest request =
          await client.getUrl(Uri.parse(song.image!));

      final HttpClientResponse response = await request.close();

      final bytes2 = await consolidateHttpClientResponseBytes(response);

      final File file2 = File(filePathParam.imagePath);

      file2.writeAsBytesSync(bytes2);
      Constants.logger.i('Image downloaded, editing tags');
      showToast('download completed');
      try {
        Constants.logger.i('Started tag editing');
        final Tag tag = Tag(
            title: song.title,
            artist: song.moreInfo!.singers,
            album: song.album,
            artwork: filePathParam.imagePath,
            comment: 'MusicBox');

        final tagger = Audiotagger();
        await tagger.writeTags(path: filePathParam.musicPath, tag: tag);
        Constants.logger.i('Completed tag editing');
      } catch (e) {
        Constants.logger.e('Error editing tags: $e');
      }

      client.close();
      Constants.logger.i('Closing connection');
      emit(state.copyWith(progress: 0.0));

      final songData = MyMusicModel(
          ytid: song.ytid,
          title: song.title,
          moreInfo: MoreInfo(singers: song.moreInfo!.singers),
          image: filePathParam.imagePath,
          songUrl: filePathParam.musicPath);

      downloadRepository.addSong(songData);

      Constants.logger.i('Saved to downloads box');
    });
  }
}
