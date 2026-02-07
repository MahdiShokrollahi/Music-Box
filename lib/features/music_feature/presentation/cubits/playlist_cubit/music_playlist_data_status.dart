import 'package:equatable/equatable.dart';
import 'package:music_box/features/music_feature/data/models/my_music_model.dart';

abstract class MusicPlaylistDataStatus extends Equatable {}

class MusicPlaylistDataLoading extends MusicPlaylistDataStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MusicPlaylistDataCompleted extends MusicPlaylistDataStatus {
  final List<MyMusicModel> songs;
  MusicPlaylistDataCompleted({required this.songs});

  @override
  // TODO: implement props
  List<Object?> get props => [songs];
}

class MusicPlaylistDataError extends MusicPlaylistDataStatus {
  final String error;

  MusicPlaylistDataError(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
