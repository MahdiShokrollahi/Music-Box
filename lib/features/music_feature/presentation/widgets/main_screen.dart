import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_box/core/widgets/custom_animated_bottom_bar.dart';
import 'package:music_box/features/download_feature/presentation/screens/downloaded_songs_screen.dart';
import 'package:music_box/features/music_feature/presentation/screens/home_screen.dart';
import 'package:music_box/features/music_feature/presentation/screens/category_screen.dart';
import 'package:music_box/features/music_feature/presentation/widgets/floating_player.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const routeName = '/main_wrapper';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final items = <BottomNavBarItem>[
    BottomNavBarItem(
      icon: const Icon(Icons.home),
      title: const Text(
        'home',
        maxLines: 1,
      ),
      activeColor: Colors.redAccent,
      inactiveColor: Colors.black,
    ),
    BottomNavBarItem(
      icon: const Icon(CupertinoIcons.music_albums),
      title: const Text(
        'playlists',
        maxLines: 1,
      ),
      activeColor: Colors.redAccent,
      inactiveColor: Colors.black,
    ),
    BottomNavBarItem(
      icon: const Icon(Icons.more_horiz),
      title: const Text(
        'settings',
        maxLines: 1,
      ),
      activeColor: Colors.redAccent,
      inactiveColor: Colors.black,
    )
  ];
  final int homeScreenIndex = 0;
  final int playlistScreenIndex = 1;
  final int settingScreenIndex = 2;
  late int currentScreenIndex = homeScreenIndex;

  final GlobalKey<NavigatorState> homeScreenKey = GlobalKey();
  final GlobalKey<NavigatorState> playlistScreenKey = GlobalKey();
  final GlobalKey<NavigatorState> settingScreenKey = GlobalKey();

  late final indexToKeyMap = {
    homeScreenIndex: homeScreenKey,
    playlistScreenIndex: playlistScreenKey,
    settingScreenIndex: settingScreenKey
  };

  final List<int> screenHistory = [];

  Future<bool> onWillPop() async {
    final NavigatorState currentNavigatorState =
        indexToKeyMap[currentScreenIndex]!.currentState!;
    if (currentNavigatorState.canPop()) {
      currentNavigatorState.pop();
      return false;
    } else if (screenHistory.isNotEmpty) {
      setState(() {
        currentScreenIndex = screenHistory.last;
        screenHistory.removeLast();
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: IndexedStack(
            index: currentScreenIndex,
            children: [
              navigator(
                  screenIndex: homeScreenIndex,
                  key: homeScreenKey,
                  child: const HomeScreen()),
              navigator(
                  screenIndex: playlistScreenIndex,
                  key: playlistScreenKey,
                  child: CategoryScreen()),
              navigator(
                  screenIndex: settingScreenIndex,
                  key: settingScreenKey,
                  child: const DownloadedSongsScreen()),
            ],
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [const FloatingPlayer(), _buildBottomBar(context, items)],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, List<BottomNavBarItem> items) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: 65,
      child: CustomAnimatedBottomBar(
        backgroundColor: Colors.grey.shade800,
        selectedIndex: currentScreenIndex,
        onItemSelected: (index) => setState(() {
          screenHistory.remove(currentScreenIndex);
          screenHistory.add(currentScreenIndex);
          currentScreenIndex = index;
        }),
        items: items,
      ),
    );
  }

  Widget navigator({
    required int screenIndex,
    required GlobalKey key,
    required Widget child,
  }) =>
      key.currentState == null && screenIndex != currentScreenIndex
          ? Container()
          : Navigator(
              key: key,
              onGenerateRoute: (settings) => MaterialPageRoute(
                  builder: (context) => Offstage(
                      offstage: currentScreenIndex != screenIndex,
                      child: child)));
}
