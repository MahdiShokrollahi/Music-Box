part of 'playlist_cubit.dart';


class PlaylistState extends Equatable {

  SearchPlaylistsDataStatus searchPlaylistsDataStatus;


  MusicPlaylistDataStatus musicPlaylistDataStatus;


  bool sortByName;


  bool sortByDuration;


  bool isAscending;


  PlaylistState(

      {required this.searchPlaylistsDataStatus,

      required this.musicPlaylistDataStatus,

      required this.sortByName,

      required this.sortByDuration,

      required this.isAscending});


  @override

  List<Object> get props => [
        searchPlaylistsDataStatus,
        musicPlaylistDataStatus,
        sortByName,
        sortByDuration,
        isAscending
      ];


  PlaylistState copyWith(

      {SearchPlaylistsDataStatus? newPlaylistsDataStatus,

      MusicPlaylistDataStatus? newMusicPlaylistDataStatus,

      bool? sortByName,

      bool? sortByDuration,

      bool? isAscending}) {

    return PlaylistState(

        searchPlaylistsDataStatus:

            newPlaylistsDataStatus ?? searchPlaylistsDataStatus,

        musicPlaylistDataStatus:

            newMusicPlaylistDataStatus ?? musicPlaylistDataStatus,
        sortByName: sortByName ?? this.sortByName,
        sortByDuration: sortByDuration ?? this.sortByDuration,
        isAscending: isAscending ?? this.isAscending);

  }

}

