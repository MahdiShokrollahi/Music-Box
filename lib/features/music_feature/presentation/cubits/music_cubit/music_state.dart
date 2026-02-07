// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audio_service/audio_service.dart';
import 'package:equatable/equatable.dart';

import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_cubit.dart';

class MusicState extends Equatable {
  final MusicControllerStatus musicControllerStatus;
  final List<MediaItem> currentQueue;
  final MediaItem? currentSong;
  final int currentSongIndex;
  final bool isLoopModeEnabled;
  const MusicState({
    this.currentSong,
    required this.currentSongIndex,
    required this.isLoopModeEnabled,
    required this.musicControllerStatus,
    required this.currentQueue,
  });

  MusicState copyWith(
      {MusicControllerStatus? musicControllerStatus,
      List<MediaItem>? currentQueue,
      bool? isLoopModeEnabled,
      int? currentSongIndex,
      MediaItem? currentSong}) {
    return MusicState(
      musicControllerStatus:
          musicControllerStatus ?? this.musicControllerStatus,
      currentQueue: currentQueue ?? this.currentQueue,
      isLoopModeEnabled: isLoopModeEnabled ?? this.isLoopModeEnabled,
      currentSong: currentSong ?? this.currentSong,
      currentSongIndex: currentSongIndex ?? this.currentSongIndex,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        musicControllerStatus,
        currentQueue,
        isLoopModeEnabled,
        currentSong,
        currentSongIndex
      ];
}
