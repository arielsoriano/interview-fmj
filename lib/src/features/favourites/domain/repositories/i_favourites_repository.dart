abstract class IFavouritesRepository {
  Future<List<String>> getFavouriteIds();

  Future<void> addFavourite(String eventId);

  Future<void> removeFavourite(String eventId);

  Future<bool> isFavourite(String eventId);
}
