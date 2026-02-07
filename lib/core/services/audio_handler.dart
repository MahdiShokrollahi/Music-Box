import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_box/core/services/audio_manger.dart';
import 'package:music_box/core/services/downlaod_manager.dart';
import 'package:music_box/core/services/service_locator.dart';
import 'package:music_box/features/download_feature/data/repository/download_repository.dart';

class MyAudioHandler extends BaseAudioHandler {
  var currentIndex;
  bool loopModeEnabled = false;
  final ConcatenatingAudioSource _playlist =
      ConcatenatingAudioSource(children: []);
  IDownloadRepository downloadRepository = locator();
  MyAudioHandler() {
    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForSequenceStateChanges();
    _listenForPositionChanges();
  }

  @override
  Future<void> onTaskRemoved() async {
    await player.stop().then((_) => player.dispose());
    await super.onTaskRemoved();
  }

  Future<void> _loadEmptyPlaylist() async {
    try {
      await player.setAudioSource(_playlist);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = player.playing;
      playbackState.add(
        playbackState.value.copyWith(
          controls: [
            MediaControl.skipToPrevious,
            if (playing) MediaControl.pause else MediaControl.play,
            MediaControl.skipToNext,
            MediaControl.stop
          ],
          systemActions: const {
            MediaAction.seek,
          },
          androidCompactActionIndices: const [0, 1, 3],
          processingState: const {
            ProcessingState.idle: AudioProcessingState.idle,
            ProcessingState.loading: AudioProcessingState.loading,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[player.processingState]!,
          repeatMode: const {
            LoopMode.off: AudioServiceRepeatMode.none,
            LoopMode.one: AudioServiceRepeatMode.one,
            LoopMode.all: AudioServiceRepeatMode.all,
          }[player.loopMode]!,
          shuffleMode: (player.shuffleModeEnabled)
              ? AudioServiceShuffleMode.all
              : AudioServiceShuffleMode.none,
          playing: playing,
          updatePosition: player.position,
          bufferedPosition: player.bufferedPosition,
          speed: player.speed,
          queueIndex: currentIndex,
        ),
      );
    });
  }

  void _listenForDurationChanges() {
    player.durationStream.listen((duration) async {
      var index = currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (player.shuffleModeEnabled) {
        index = player.shuffleIndices![index];
      }
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  void _listenForPositionChanges() {
    player.positionStream.listen((position) async {
      final durationIsNotNull = player.duration != null;
      if (durationIsNotNull &&
          position.inSeconds >= player.duration!.inSeconds) {
        await _triggerNext();
      }
    });
  }

  Future<void> _triggerNext() async {
    if (loopModeEnabled) {
      await player.seek(Duration.zero);
      if (!player.playing) {
        player.play();
      }
      return;
    }
    skipToNext();
  }

  void _listenForSequenceStateChanges() {
    player.sequenceStateStream.listen((SequenceState? sequenceState) {
      final sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) return;
    });
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  @override
  Future<void> updateQueue(List<MediaItem> queue) async {
    final newQueue = this.queue.value
      ..replaceRange(0, this.queue.value.length, queue);
    this.queue.add(newQueue);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    final newQueue = queue.value..add(mediaItem);
    queue.add(newQueue);
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(
      DownLoadManager.isSongDownloaded(mediaItem.id)
          ? Uri.file(mediaItem.extras!['url'].toString())
          : Uri.parse(mediaItem.extras!['url'].toString()),
      tag: mediaItem,
    );
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    await _playlist.removeAt(index);

    final newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }

  @override
  // ignore: avoid_renaming_method_parameters
  Future<void> removeQueueItem(MediaItem mediaItem_) async {
    final currentQueue = queue.value;
    final currentSong = mediaItem.value;
    final itemIndex = currentQueue.indexOf(mediaItem_);
    if (currentIndex > itemIndex) {
      currentIndex -= 1;
    }
    currentQueue.remove(mediaItem_);
    queue.add(currentQueue);
    mediaItem.add(currentSong);
  }

  @override
  Future<void> play() => player.play();

  @override
  Future<void> pause() => player.pause();

  @override
  Future<void> seek(Duration position) => player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    await customAction("playByIndex", {'index': index});
  }

  @override
  Future<void> skipToNext() async {
    if (queue.value.length > currentIndex + 1) {
      player.seek(Duration.zero);
      await customAction("playByIndex", {'index': currentIndex + 1});
    } else {
      player.seek(Duration.zero);
      player.pause();
    }
  }

  @override
  Future<void> skipToPrevious() async {
    player.seek(Duration.zero);
    if (currentIndex - 1 >= 0) {
      await customAction("playByIndex", {'index': currentIndex - 1});
    }
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    if (repeatMode == AudioServiceRepeatMode.none) {
      loopModeEnabled = false;
    } else {
      loopModeEnabled = true;
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      player.setShuffleModeEnabled(false);
    } else {
      await player.shuffle();
      player.setShuffleModeEnabled(true);
    }
  }

  @override
  Future customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'dispose') {
      await player.dispose();
      super.stop();
    } else if (name == 'playByIndex') {
      if (_playlist.children.isNotEmpty) {
        await _playlist.clear();
      }
      currentIndex = extras!['index'];
      final currentSong = queue.value[currentIndex];
      mediaItem.add(currentSong);

      if (!DownLoadManager.isSongDownloaded(currentSong.id)) {
        final url = await getUrl(currentSong.id);

        currentSong.extras!['url'] = url;
      }
      playbackState.add(playbackState.value.copyWith(queueIndex: currentIndex));

      await _playlist.add(_createAudioSource(currentSong));

      await player.play();
      cacheNextSongUrl();
    } else if (name == "shuffleQueue") {
      final currentQueue = queue.value;
      final currentItem = currentQueue[currentIndex];
      currentQueue.remove(currentItem);
      currentQueue.shuffle();
      currentQueue.insert(0, currentItem);
      queue.add(currentQueue);
      mediaItem.add(currentItem);
      currentIndex = 0;
      cacheNextSongUrl();
    } else if (name == "reorderQueue") {
      final oldIndex = extras!['oldIndex'];
      int newIndex = extras['newIndex'];

      if (oldIndex < newIndex) {
        newIndex--;
      }

      final currentQueue = queue.value;
      final currentItem = currentQueue[currentIndex];
      final item = currentQueue.removeAt(
        oldIndex,
      );
      currentQueue.insert(newIndex, item);
      currentIndex = currentQueue.indexOf(currentItem);
      queue.add(currentQueue);
      mediaItem.add(currentItem);
    }
  }

  Future<void> cacheNextSongUrl() async {
    if (queue.value.length > currentIndex + 1) {
      await getUrl((queue.value[currentIndex + 1]).id);
      debugPrint("Next Song Url Cached");
    }
  }

  @override
  Future<void> stop() async {
    await player.stop();
    return super.stop();
  }
}
