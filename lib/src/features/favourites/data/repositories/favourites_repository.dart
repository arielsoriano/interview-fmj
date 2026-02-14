import 'package:city_events_explorer/src/features/favourites/data/datasources/local_favourites_datasource.dart';
import 'package:city_events_explorer/src/features/favourites/domain/repositories/i_favourites_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IFavouritesRepository)
class FavouritesRepository implements IFavouritesRepository {
  FavouritesRepository(this._datasource);

  final LocalFavouritesDatasource _datasource;

  @override
  Future<List<String>> getFavouriteIds() async {
    return _datasource.load();
  }

  @override
  Future<void> addFavourite(String eventId) async {
    await _datasource.add(eventId);
  }

  @override
  Future<void> removeFavourite(String eventId) async {
    await _datasource.remove(eventId);
  }

  @override
  Future<bool> isFavourite(String eventId) async {
    final ids = await _datasource.load();
    return ids.contains(eventId);
  }
}
