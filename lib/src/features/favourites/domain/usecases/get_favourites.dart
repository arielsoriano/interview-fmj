import 'package:city_events_explorer/src/features/favourites/domain/repositories/i_favourites_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFavouritesUseCase {
  GetFavouritesUseCase(this._repository);

  final IFavouritesRepository _repository;

  Future<List<String>> call() async {
    return _repository.getFavouriteIds();
  }
}
