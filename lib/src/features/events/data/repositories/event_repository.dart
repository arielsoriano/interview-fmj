import 'package:city_events_explorer/src/features/events/data/datasources/local_event_datasource.dart';
import 'package:city_events_explorer/src/features/events/domain/entities/event.dart';
import 'package:city_events_explorer/src/features/events/domain/repositories/i_event_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IEventRepository)
class EventRepository implements IEventRepository {
  EventRepository(this._localDatasource);

  final LocalEventDatasource _localDatasource;

  @override
  Future<List<Event>> getEvents() async {
    final eventModels = await _localDatasource.loadEventsFromJson();
    return eventModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Event>> searchEvents(String query) async {
    final events = await getEvents();
    final lowercaseQuery = query.toLowerCase();
    return events
        .where(
          (event) =>
              event.title.toLowerCase().contains(lowercaseQuery) ||
              event.description.toLowerCase().contains(lowercaseQuery),
        )
        .toList();
  }

  @override
  Future<List<Event>> filterByCategory(String category) async {
    final events = await getEvents();
    return events
        .where(
          (event) =>
              event.category.toLowerCase() == category.toLowerCase(),
        )
        .toList();
  }

  @override
  Future<List<Event>> filterByDateRange(DateTime start, DateTime end) async {
    final events = await getEvents();
    return events
        .where(
          (event) =>
              event.startDate.isAfter(start) &&
              event.startDate.isBefore(end.add(const Duration(days: 1))),
        )
        .toList();
  }
}
