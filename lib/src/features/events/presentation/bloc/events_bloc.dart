import 'package:city_events_explorer/src/features/events/domain/entities/event.dart';
import 'package:city_events_explorer/src/features/events/domain/usecases/filter_events_by_category.dart';
import 'package:city_events_explorer/src/features/events/domain/usecases/get_events.dart';
import 'package:city_events_explorer/src/features/events/domain/usecases/search_events.dart';
import 'package:city_events_explorer/src/features/favourites/domain/repositories/i_favourites_repository.dart';
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
  const factory EventsEvent.toggleShowOnlyFavourites() =
      _ToggleShowOnlyFavourites;
}

@freezed
class EventsState with _$EventsState {
  const factory EventsState.initial() = _Initial;
  const factory EventsState.loading() = _Loading;
  const factory EventsState.loaded(
    List<Event> events, {
    @Default(false) bool showOnlyFavourites,
  }) = _Loaded;
  const factory EventsState.error(String message) = _Error;
}

@injectable
class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc(
    this._getEventsUseCase,
    this._searchEventsUseCase,
    this._filterEventsByCategoryUseCase,
    this._favouritesRepository,
  ) : super(const EventsState.initial()) {
    on<_LoadEvents>(_onLoadEvents);
    on<_SearchEvents>(_onSearchEvents);
    on<_FilterByCategory>(_onFilterByCategory);
    on<_ClearFilters>(_onClearFilters);
    on<_ToggleShowOnlyFavourites>(_onToggleShowOnlyFavourites);
  }

  final GetEventsUseCase _getEventsUseCase;
  final SearchEventsUseCase _searchEventsUseCase;
  final FilterEventsByCategoryUseCase _filterEventsByCategoryUseCase;
  final IFavouritesRepository _favouritesRepository;

  List<Event> _allEvents = [];
  bool _showOnlyFavourites = false;

  Future<void> _onLoadEvents(
    _LoadEvents event,
    Emitter<EventsState> emit,
  ) async {
    emit(const EventsState.loading());
    try {
      _allEvents = await _getEventsUseCase();
      _showOnlyFavourites = false;
      emit(EventsState.loaded(_allEvents));
    } on Exception catch (e) {
      emit(EventsState.error(e.toString()));
    }
  }

  Future<void> _onSearchEvents(
    _SearchEvents event,
    Emitter<EventsState> emit,
  ) async {
    emit(const EventsState.loading());
    try {
      _allEvents = await _searchEventsUseCase(event.query);
      _showOnlyFavourites = false;
      final filteredEvents = await _applyFavouritesFilter(_allEvents);
      emit(
        EventsState.loaded(
          filteredEvents,
          showOnlyFavourites: _showOnlyFavourites,
        ),
      );
    } on Exception catch (e) {
      emit(EventsState.error(e.toString()));
    }
  }

  Future<void> _onFilterByCategory(
    _FilterByCategory event,
    Emitter<EventsState> emit,
  ) async {
    emit(const EventsState.loading());
    try {
      _allEvents = await _filterEventsByCategoryUseCase(event.category);
      _showOnlyFavourites = false;
      final filteredEvents = await _applyFavouritesFilter(_allEvents);
      emit(
        EventsState.loaded(
          filteredEvents,
          showOnlyFavourites: _showOnlyFavourites,
        ),
      );
    } on Exception catch (e) {
      emit(EventsState.error(e.toString()));
    }
  }

  Future<void> _onClearFilters(
    _ClearFilters event,
    Emitter<EventsState> emit,
  ) async {
    emit(const EventsState.loading());
    try {
      _allEvents = await _getEventsUseCase();
      _showOnlyFavourites = false;
      emit(EventsState.loaded(_allEvents));
    } on Exception catch (e) {
      emit(EventsState.error(e.toString()));
    }
  }

  Future<void> _onToggleShowOnlyFavourites(
    _ToggleShowOnlyFavourites event,
    Emitter<EventsState> emit,
  ) async {
    _showOnlyFavourites = !_showOnlyFavourites;
    final filteredEvents = await _applyFavouritesFilter(_allEvents);
    emit(
      EventsState.loaded(
        filteredEvents,
        showOnlyFavourites: _showOnlyFavourites,
      ),
    );
  }

  Future<List<Event>> _applyFavouritesFilter(List<Event> events) async {
    if (!_showOnlyFavourites) {
      return events;
    }
    final favouriteIds = await _favouritesRepository.getFavouriteIds();
    return events.where((event) => favouriteIds.contains(event.id)).toList();
  }
}
