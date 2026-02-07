import 'package:equatable/equatable.dart';
import 'package:music_box/features/music_feature/data/models/my_playlist_model.dart';

abstract class SearchPlaylistsDataStatus extends Equatable {}

class SearchPlaylistsDataLoading extends SearchPlaylistsDataStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SearchPlaylistsDataCompleted extends SearchPlaylistsDataStatus {
  final List<MyPlaylistModel> playlists;

  SearchPlaylistsDataCompleted({required this.playlists});

  @override
  // TODO: implement props
  List<Object?> get props => [playlists];
}

class SearchPlaylistsDataError extends SearchPlaylistsDataStatus {
  final String error;

  SearchPlaylistsDataError(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
