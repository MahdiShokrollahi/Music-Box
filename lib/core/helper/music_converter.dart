import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_box/core/services/downlaod_manager.dart';
import 'package:music_box/core/services/service_locator.dart';
import 'package:music_box/features/download_feature/data/repository/download_repository.dart';
import 'package:music_box/features/music_feature/data/models/my_music_model.dart';

class MusicConverter {
  static IDownloadRepository downloadRepository = locator();
  static MediaItem songToMediaItem(MyMusicModel song) {
    return MediaItem(
      id: song.ytid.toString(),
      album: '',
      artist: song.moreInfo!.singers!,
      title: song.title!,
      artUri: DownLoadManager.isSongDownloaded(song.ytid!)
          ? Uri.file(downloadRepository
              .getSongDownloadById(song.ytid.toString())
              .image!)
          : Uri.parse(song.highResImage!),
      extras: {
        'url': DownLoadManager.isSongDownloaded(song.ytid!)
            ? downloadRepository
                .getSongDownloadById(song.ytid.toString())
                .songUrl!
            : '',
        'lowResImage': song.lowResImage,
        'index': song.id,
      },
    );
  }

  static AudioSource songToAudioSource(MyMusicModel song, {String? songUrl}) {
    return AudioSource.uri(Uri.parse(songUrl ?? ''),
        tag: MediaItem(
            id: song.id.toString(),
            album: '',
            artist: song.moreInfo!.singers!.toString(),
            title: song.title.toString(),
            artUri: Uri.parse(
              song.lowResImage.toString(),
            )));
  }
}
