import 'package:city_events_explorer/src/features/favourites/domain/repositories/i_favourites_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ToggleFavouriteUseCase {
  ToggleFavouriteUseCase(this._repository);

  final IFavouritesRepository _repository;

  Future<void> call(String eventId) async {
    final isFavourite = await _repository.isFavourite(eventId);
    if (isFavourite) {
      await _repository.removeFavourite(eventId);
    } else {
      await _repository.addFavourite(eventId);
    }
  }
}
