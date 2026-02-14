import 'package:city_events_explorer/src/features/events/domain/entities/event.dart';

abstract class IEventRepository {
  Future<List<Event>> getEvents();

  Future<List<Event>> searchEvents(String query);

  Future<List<Event>> filterByCategory(String category);

  Future<List<Event>> filterByDateRange(DateTime start, DateTime end);
}
