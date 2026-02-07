import 'package:equatable/equatable.dart';
import 'package:music_box/features/music_feature/data/models/my_playlist_model.dart';

abstract class SuggestedPlaylistsDataStatus extends Equatable {}

class SuggestedPlaylistsDataLoading extends SuggestedPlaylistsDataStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SuggestedPlaylistsDataCompleted extends SuggestedPlaylistsDataStatus {
  final List<MyPlaylistModel> suggestedPlaylists;

  SuggestedPlaylistsDataCompleted({required this.suggestedPlaylists});

  @override
  // TODO: implement props
  List<Object?> get props => [suggestedPlaylists];
}

class SuggestedPlaylistsDataError extends SuggestedPlaylistsDataStatus {
  final String error;

  SuggestedPlaylistsDataError(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
