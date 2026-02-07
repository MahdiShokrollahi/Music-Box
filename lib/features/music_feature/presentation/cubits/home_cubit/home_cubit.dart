import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_box/features/music_feature/data/repository/music_repository.dart';
import 'package:music_box/features/music_feature/presentation/cubits/home_cubit/palylists_data_status.dart';
import 'package:music_box/features/music_feature/presentation/cubits/home_cubit/songs_data_status.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final IMusicRepository repository;
  HomeCubit(this.repository)
      : super(HomeState(
            playlistsDataStatus: SuggestedPlaylistsDataLoading(),
            songsDataStatus: SongsDataLoading()));

  Future<void> getPlaylists() async {
    emit(
        state.copyWith(newPlaylistDataStatus: SuggestedPlaylistsDataLoading()));
    var suggestedPlaylists = await repository.getPlayLists(5);

    suggestedPlaylists.fold((error) {
      state.copyWith(newPlaylistDataStatus: SuggestedPlaylistsDataError(error));
    }, (suggestedPlaylists) {
      emit(state.copyWith(
          newPlaylistDataStatus: SuggestedPlaylistsDataCompleted(
              suggestedPlaylists: suggestedPlaylists)));
    });
  }

  getSongs() async {
    emit(state.copyWith(newSongsDataStatus: SongsDataLoading()));
    var songs =
        await repository.getMusicPlaylist('PLgzTt0k8mXzEk586ze4BjvDXR7c-TUSnx');
    songs.fold((error) {
      emit(state.copyWith(newSongsDataStatus: SongsDataError(error)));
    }, (songs) {
      emit(
          state.copyWith(newSongsDataStatus: SongsDataCompleted(songs: songs)));
    });
  }
}
