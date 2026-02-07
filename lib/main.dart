import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_box/core/services/service_locator.dart';
import 'package:music_box/core/utils/constants.dart';
import 'package:music_box/features/music_feature/data/models/more_info.dart';
import 'package:music_box/features/music_feature/data/models/my_music_model.dart';
import 'package:music_box/features/music_feature/presentation/cubits/music_cubit/music_cubit.dart';
import 'package:music_box/features/music_feature/presentation/widgets/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<MoreInfo>(MoreInfoAdapter());
  Hive.registerAdapter<MyMusicModel>(MyMusicModelAdapter());
  await Hive.openBox<MyMusicModel>(Constants.downloadBox);
  await Hive.openBox<String>('SongsUrlCache');

  await setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MusicCubit>(
      create: (context) => locator<MusicCubit>()..init(),
      lazy: false,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainScreen(),
      ),
    );
  }
}
