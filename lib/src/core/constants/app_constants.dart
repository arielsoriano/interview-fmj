abstract class AppConstants {
  static const String appName = 'City Events Explorer';
  
  static const String eventsJsonPath = 'assets/data/events.json';
  
  static const String sharedPrefsKeyFavourites = 'favourite_event_ids';
  
  static const int itemsPerPage = 20;
  static const int searchDebounceMilliseconds = 500;
  
  static const double mapZoomLevel = 15;
  static const double mapMinZoomLevel = 3;
  static const double mapMaxZoomLevel = 18;
  
  static const String mapTileUrl = 
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String mapUserAgentName = 'CityEventsExplorer';
  
  static const int animationDurationShort = 200;
  static const int animationDurationMedium = 300;
  static const int animationDurationLong = 500;
  
  static const Duration cacheDuration = Duration(hours: 1);
  static const Duration requestTimeout = Duration(seconds: 30);
  
  static const List<String> eventCategories = [
    'All',
    'Health & Wellness',
    'Music',
    'Food & Drink',
    'Art & Culture',
    'Sports & Fitness',
    'Technology',
  ];
  
  static const String dateFormatDisplay = 'MMM dd, yyyy';
  static const String timeFormatDisplay = 'h:mm a';
  static const String dateTimeFormatDisplay = 'MMM dd, yyyy · h:mm a';
  static const String dateFormatFull = 'EEEE, MMMM dd, yyyy';
  
  static const String errorGeneric = 'An error occurred. Please try again.';
  static const String errorNetwork = 
      'Network error. Please check your connection.';
  static const String errorNoEvents = 'No events found.';
  static const String errorLoadingEvents = 'Failed to load events.';
  static const String errorInvalidData = 'Invalid event data.';
  
  static const String messageNoFavourites = 'No favourite events yet.';
  static const String messageNoSearchResults = 'No events match your search.';
  static const String messageAddedToFavourites = 'Added to favourites';
  static const String messageRemovedFromFavourites = 'Removed from favourites';
}
