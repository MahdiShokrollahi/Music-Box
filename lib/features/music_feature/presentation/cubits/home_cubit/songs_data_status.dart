import 'package:equatable/equatable.dart';
import 'package:music_box/features/music_feature/data/models/my_music_model.dart';

abstract class SongsDataStatus extends Equatable {}

class SongsDataLoading extends SongsDataStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SongsDataCompleted extends SongsDataStatus {
  final List<MyMusicModel> songs;
  SongsDataCompleted({required this.songs});

  @override
  // TODO: implement props
  List<Object?> get props => [songs];
}

class SongsDataError extends SongsDataStatus {
  final String error;

  SongsDataError(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
