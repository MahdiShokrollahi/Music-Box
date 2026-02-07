part of 'music_cubit.dart';


abstract class MusicControllerStatus extends Equatable {

  @override


  // TODO: implement props


  List<Object?> get props => [];

}


class MusicControllerPlayingStatus extends MusicControllerStatus {}


class MusicControllerPauseStatus extends MusicControllerStatus {}


class MusicControllerIdleStatus extends MusicControllerStatus {}

