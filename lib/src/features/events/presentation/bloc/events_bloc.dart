import 'package:city_events_explorer/src/features/events/domain/entities/event.dart';
import 'package:city_events_explorer/src/features/events/domain/usecases/filter_events_by_category.dart';
import 'package:city_events_explorer/src/features/events/domain/usecases/get_events.dart';
import 'package:city_events_explorer/src/features/events/domain/usecases/search_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'events_bloc.freezed.dart';

@freezed
class EventsEvent with _$EventsEvent {
  const factory EventsEvent.loadEvents() = _LoadEvents;
  const factory EventsEvent.searchEvents(String query) = _SearchEvents;
  const factory EventsEvent.filterByCategory(String category) =
      _FilterByCategory;
  const factory EventsEvent.clearFilters() = _ClearFilters;
}

@freezed
class EventsState with _$EventsState {
  const factory EventsState.initial() = _Initial;
  const factory EventsState.loading() = _Loading;
  const factory EventsState.loaded(List<Event> events) = _Loaded;
  const factory EventsState.error(String message) = _Error;
}

@injectable
class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc(
    this._getEventsUseCase,
    this._searchEventsUseCase,
    this._filterEventsByCategoryUseCase,
  ) : super(const EventsState.initial()) {
    on<_LoadEvents>(_onLoadEvents);
    on<_SearchEvents>(_onSearchEvents);
    on<_FilterByCategory>(_onFilterByCategory);
    on<_ClearFilters>(_onClearFilters);
  }

  final GetEventsUseCase _getEventsUseCase;
  final SearchEventsUseCase _searchEventsUseCase;
  final FilterEventsByCategoryUseCase _filterEventsByCategoryUseCase;

  Future<void> _onLoadEvents(
    _LoadEvents event,
    Emitter<EventsState> emit,
  ) async {
    emit(const EventsState.loading());
    try {
      final events = await _getEventsUseCase();
      emit(EventsState.loaded(events));
    } catch (e) {
      emit(EventsState.error(e.toString()));
    }
  }

  Future<void> _onSearchEvents(
    _SearchEvents event,
    Emitter<EventsState> emit,
  ) async {
    emit(const EventsState.loading());
    try {
      final events = await _searchEventsUseCase(event.query);
      emit(EventsState.loaded(events));
    } catch (e) {
      emit(EventsState.error(e.toString()));
    }
  }

  Future<void> _onFilterByCategory(
    _FilterByCategory event,
    Emitter<EventsState> emit,
  ) async {
    emit(const EventsState.loading());
    try {
      final events = await _filterEventsByCategoryUseCase(event.category);
      emit(EventsState.loaded(events));
    } catch (e) {
      emit(EventsState.error(e.toString()));
    }
  }

  Future<void> _onClearFilters(
    _ClearFilters event,
    Emitter<EventsState> emit,
  ) async {
    emit(const EventsState.loading());
    try {
      final events = await _getEventsUseCase();
      emit(EventsState.loaded(events));
    } catch (e) {
      emit(EventsState.error(e.toString()));
    }
  }
}
