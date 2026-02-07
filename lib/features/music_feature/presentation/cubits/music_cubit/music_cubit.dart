import 'package:audio_service/audio_service.dart';

import 'package:audio_session/audio_session.dart';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import 'package:music_box/core/services/audio_manger.dart';

import 'package:music_box/features/music_feature/data/models/my_music_model.dart';

import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_state.dart';

part 'music_controller_status.dart';

class MusicCubit extends Cubit<MusicState> {
  final AudioHandler _audioHandler;

  MusicCubit(this._audioHandler)
      : super(MusicState(
            musicControllerStatus: MusicControllerIdleStatus(),
            currentQueue: const [],
            isLoopModeEnabled: false,
            currentSongIndex: 0));

  init() async {
    final session = await AudioSession.instance;

    await session.configure(const AudioSessionConfiguration.speech());

    emit(state.copyWith(musicControllerStatus: MusicControllerIdleStatus()));

    listenForChangesMediaItem();

    listenForPlaylistChange();
  }

  playPlayList(List<MyMusicModel> playlist, int index) async {
    try {
      await enqueueSongList(playlist);

      _audioHandler.customAction("playByIndex", {"index": index});

      emit(state.copyWith(

          // currentSongIndex: index,

          // currentSong: MusicConverter.songToMediaItem(playlist[index]),

          musicControllerStatus: MusicControllerPlayingStatus()));
    } catch (e, stackTrace) {
      print("Error loading song: $e");

      print(stackTrace);
    }
  }

  void listenForPlaylistChange() {
    _audioHandler.queue.listen((queue) {
      emit(state.copyWith(currentQueue: queue));
    });
  }

  listenForChangesMediaItem() {
    _audioHandler.mediaItem.listen((mediaItem) {
      if (mediaItem != null) {
        final songIndex = state.currentQueue
            .indexWhere((element) => element.id == mediaItem.id);

        emit(state.copyWith(
            currentSong: mediaItem, currentSongIndex: songIndex));
      }
    });
  }

  play({int? index}) async {
    if (index != null) {
      _audioHandler.customAction("playByIndex", {'index': index});
    }

    _audioHandler.play();

    emit(state.copyWith(musicControllerStatus: MusicControllerPlayingStatus()));
  }

  pause() async {
    _audioHandler.pause();

    emit(state.copyWith(musicControllerStatus: MusicControllerPauseStatus()));
  }

  stop() {
    _audioHandler.onTaskRemoved();

    emit(state.copyWith(musicControllerStatus: MusicControllerIdleStatus()));
  }

  onReorder({required int oldIndex, required int newIndex}) async {
    _audioHandler.customAction(
        "reorderQueue", {"oldIndex": oldIndex, "newIndex": newIndex});
  }

  toggleLoopMode() {
    state.isLoopModeEnabled
        ? _audioHandler.setRepeatMode(AudioServiceRepeatMode.none)
        : _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);

    emit(state.copyWith(isLoopModeEnabled: !state.isLoopModeEnabled));
  }

  shuffleQueue() {
    _audioHandler.customAction("shuffleQueue");
  }

  next() async {
    _audioHandler.skipToNext();

    // emit(state.copyWith(currentSongIndex: state.currentSongIndex + 1));
  }

  previous() async {
    _audioHandler.skipToPrevious();

    // emit(state.copyWith(currentSongIndex: state.currentSongIndex - 1));
  }

  remove({required int index}) {
    state.currentQueue.removeAt(index);
  }
}
