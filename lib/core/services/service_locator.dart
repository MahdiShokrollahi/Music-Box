import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:music_box/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:music_box/core/services/audio_handler.dart';
import 'package:music_box/core/utils/constants.dart';
import 'package:music_box/features/download_feature/data/data_source/download_data_source.dart';
import 'package:music_box/features/download_feature/data/repository/download_repository.dart';
import 'package:music_box/features/music_feature/data/data_source/remote/music_remote_data_source.dart';
import 'package:music_box/features/music_feature/data/models/my_music_model.dart';
import 'package:music_box/features/music_feature/data/repository/music_repository.dart';
import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_cubit.dart';

var locator = GetIt.instance;

Future<void> setup() async {
  //*dataSources
  locator
      .registerFactory<IMusicRemoteDataSource>(() => MusicRemoteDataSource());
  final box = Hive.box<MyMusicModel>(Constants.downloadBox);
  locator.registerFactory<IDownloadDataSource>(() => DownloadDataSource(box));

  //*repositories
  locator.registerFactory<IMusicRepository>(() => MusicRepository(locator()));
  locator.registerFactory<IDownloadRepository>(
      () => DownloadRepository(locator()));

  //*services
  final audioHandler = await AudioService.init(
    builder: MyAudioHandler.new,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mahdiDev.music_box',
      androidNotificationChannelName: 'MusicBox',
    ),
  );
  locator.registerSingleton<AudioHandler>(audioHandler);

  //*blocs
  locator.registerSingleton<MusicCubit>(MusicCubit(locator()));
  locator.registerSingleton<ThemeCubit>(ThemeCubit());
}
