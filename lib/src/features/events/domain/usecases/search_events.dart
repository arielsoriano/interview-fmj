import 'package:city_events_explorer/src/features/events/domain/entities/event.dart';
import 'package:city_events_explorer/src/features/events/domain/repositories/i_event_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchEventsUseCase {
  SearchEventsUseCase(this._repository);

  final IEventRepository _repository;

  Future<List<Event>> call(String query) => _repository.searchEvents(query);
}
