import 'package:hive/hive.dart';
import 'package:music_box/features/music_feature/data/models/my_music_model.dart';

abstract class IFavoritesDataSource {
  Future<void> addFavorite(String id);
  Future<void> removeFavorite(String id);
  Future<bool> isFavorite(String id);
  Future<List<String>> getFavorites();
}

class FavoritesDataSource extends IFavoritesDataSource {
  final Box<MyMusicModel> box;
  FavoritesDataSource(this.box);

  @override
  Future<void> addFavorite(String id) {
    box.add(id);
  }

  @override
  Future<List<String>> getFavorites() {
    // TODO: implement getFavorites
    throw UnimplementedError();
  }

  @override
  Future<bool> isFavorite(String id) {
    // TODO: implement isFavorite
    throw UnimplementedError();
  }

  @override
  Future<void> removeFavorite(String id) {
    // TODO: implement removeFavorite
    throw UnimplementedError();
  }
}
