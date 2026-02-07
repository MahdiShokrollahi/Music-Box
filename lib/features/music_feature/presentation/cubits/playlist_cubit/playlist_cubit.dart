import 'package:bloc/bloc.dart';


import 'package:equatable/equatable.dart';


import 'package:music_box/core/helper/formatter.dart';


import 'package:music_box/features/music_feature/data/models/my_music_model.dart';


import 'package:music_box/features/music_feature/data/repository/music_repository.dart';


import 'package:music_box/features/music_feature/presentation/cubits/playlist_cubit/music_playlist_data_status.dart';


import 'package:music_box/features/music_feature/presentation/cubits/playlist_cubit/playlists_data_status.dart';


part 'playlist_state.dart';


class PlaylistCubit extends Cubit<PlaylistState> {

  final IMusicRepository _repository;


  PlaylistCubit(this._repository)

      : super(PlaylistState(

            searchPlaylistsDataStatus: SearchPlaylistsDataLoading(),

            musicPlaylistDataStatus: MusicPlaylistDataLoading(),

            sortByName: false,

            sortByDuration: false,

            isAscending: true));


  loadPlaylists({String searchQuery = ''}) async {

    emit(state.copyWith(newPlaylistsDataStatus: SearchPlaylistsDataLoading()));


    final searchPlaylist = await _repository.searchPlayList(searchQuery);


    searchPlaylist.fold((error) {

      emit(state.copyWith(

          newPlaylistsDataStatus: SearchPlaylistsDataError(error)));

    }, (searchPlaylist) {

      emit(state.copyWith(

          newPlaylistsDataStatus:

              SearchPlaylistsDataCompleted(playlists: searchPlaylist)));

    });

  }


  getMusicPlaylist(String id) async {

    emit(

        state.copyWith(newMusicPlaylistDataStatus: MusicPlaylistDataLoading()));


    final result = await _repository.getMusicPlaylist(id);


    result.fold((error) {

      emit(state.copyWith(

          newMusicPlaylistDataStatus: MusicPlaylistDataError(error)));

    }, (songs) {

      emit(state.copyWith(

          newMusicPlaylistDataStatus:

              MusicPlaylistDataCompleted(songs: songs)));

    });

  }


  onSortByName(List<MyMusicModel> songs) {

    final songList = songs;


    songList.sort((a, b) => state.isAscending

        ? a.title!.toLowerCase().compareTo(b.title!.toLowerCase())

        : b.title!.toLowerCase().compareTo(a.title!.toLowerCase()));


    emit(state.copyWith(

        sortByName: true,

        sortByDuration: false,

        newMusicPlaylistDataStatus:

            MusicPlaylistDataCompleted(songs: songList)));

  }


  onSortByDuration(List<MyMusicModel> songs) {

    final songList = songs;


    songList.sort((a, b) => state.isAscending

        ? (Helper.convertTimeStringToDuration(a.duration!))

            .compareTo(Helper.convertTimeStringToDuration(b.duration!))

        : (Helper.convertTimeStringToDuration(b.duration!))

            .compareTo(Helper.convertTimeStringToDuration(a.duration!)));


    emit(state.copyWith(

        sortByName: false,

        sortByDuration: true,

        newMusicPlaylistDataStatus:

            MusicPlaylistDataCompleted(songs: songList)));

  }


  onAscendNDescend(List<MyMusicModel> songs) {

    if (state.sortByName) {

      emit(state.copyWith(isAscending: !state.isAscending));


      onSortByName(songs);

    } else if (state.sortByDuration) {

      emit(state.copyWith(isAscending: !state.isAscending));


      onSortByDuration(songs);

    }

  }

}

