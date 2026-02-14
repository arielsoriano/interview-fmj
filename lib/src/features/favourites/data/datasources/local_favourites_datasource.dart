import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class LocalFavouritesDatasource {
  LocalFavouritesDatasource._(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'favourite_event_ids';

  @preResolve
  @factoryMethod
  static Future<LocalFavouritesDatasource> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalFavouritesDatasource._(prefs);
  }

  Future<List<String>> load() async {
    return _prefs.getStringList(_key) ?? [];
  }

  Future<void> save(List<String> ids) async {
    await _prefs.setStringList(_key, ids);
  }

  Future<void> add(String id) async {
    final ids = await load();
    if (!ids.contains(id)) {
      ids.add(id);
      await save(ids);
    }
  }

  Future<void> remove(String id) async {
    final ids = await load();
    ids.remove(id);
    await save(ids);
  }
}
