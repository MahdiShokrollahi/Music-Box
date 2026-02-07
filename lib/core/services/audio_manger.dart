import 'package:audio_service/audio_service.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_box/core/helper/music_converter.dart';
import 'package:music_box/core/services/service_locator.dart';
import 'package:music_box/features/music_feature/data/models/my_music_model.dart';
import 'package:music_box/features/music_feature/data/repository/music_repository.dart';

final player = AudioPlayer();

Future<void> enqueueSongList(List<MyMusicModel> playlist) async {
  List<MediaItem> mediaItems = [];
  final audioHandler = locator<AudioHandler>();
  for (var song in playlist) {
    mediaItems.add(MusicConverter.songToMediaItem(song));
  }
  audioHandler.addQueueItems(mediaItems);
}

Future<String> getUrl(String songId) async {
  final repository = locator<IMusicRepository>();
  final songsUrlCacheBox = Hive.box<String>("SongsUrlCache");
  dynamic url;
  if (songsUrlCacheBox.containsKey(songId)) {
    url = songsUrlCacheBox.get(songId);
  } else {
    url = await repository.getSongUrl(songId);
    songsUrlCacheBox.put(songId, url);
  }
  return url;
}
