// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_cubit.dart';

class HomeState extends Equatable {
  final SuggestedPlaylistsDataStatus playlistsDataStatus;
  final SongsDataStatus songsDataStatus;

  HomeState({required this.playlistsDataStatus, required this.songsDataStatus});

  @override
  // TODO: implement props
  List<Object?> get props => [playlistsDataStatus, songsDataStatus];

  HomeState copyWith(
      {SuggestedPlaylistsDataStatus? newPlaylistDataStatus,
      SongsDataStatus? newSongsDataStatus}) {
    return HomeState(
        playlistsDataStatus: newPlaylistDataStatus ?? playlistsDataStatus,
        songsDataStatus: newSongsDataStatus ?? songsDataStatus);
  }
}
