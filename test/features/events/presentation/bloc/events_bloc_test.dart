import 'package:bloc_test/bloc_test.dart';
import 'package:city_events_explorer/src/features/events/domain/entities/event.dart';
import 'package:city_events_explorer/src/features/events/domain/entities/location.dart';
import 'package:city_events_explorer/src/features/events/domain/usecases/filter_events_by_category.dart';
import 'package:city_events_explorer/src/features/events/domain/usecases/get_events.dart';
import 'package:city_events_explorer/src/features/events/domain/usecases/search_events.dart';
import 'package:city_events_explorer/src/features/events/presentation/bloc/events_bloc.dart';
import 'package:city_events_explorer/src/features/favourites/domain/repositories/i_favourites_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetEventsUseCase extends Mock implements GetEventsUseCase {}

class MockSearchEventsUseCase extends Mock implements SearchEventsUseCase {}

class MockFilterEventsByCategoryUseCase extends Mock
    implements FilterEventsByCategoryUseCase {}

class MockFavouritesRepository extends Mock implements IFavouritesRepository {}

void main() {
  late EventsBloc bloc;
  late MockGetEventsUseCase mockGetEventsUseCase;
  late MockSearchEventsUseCase mockSearchEventsUseCase;
  late MockFilterEventsByCategoryUseCase mockFilterEventsByCategoryUseCase;
  late MockFavouritesRepository mockFavouritesRepository;

  final tEvents = [
    Event(
      id: '1',
      title: 'Sunset Yoga in the Park',
      description: 'Enjoy a relaxing yoga session at sunset.',
      category: 'Health & Wellness',
      startDate: DateTime(2025, 7, 1, 18),
      endDate: DateTime(2025, 7, 1, 19),
      imageUrl: 'https://example.com/yoga.jpg',
      location: const Location(
        name: 'Central Park',
        lat: 40.785091,
        lng: -73.968285,
      ),
    ),
    Event(
      id: '2',
      title: 'Jazz Night at the Lounge',
      description: 'Experience live jazz performances.',
      category: 'Music',
      startDate: DateTime(2025, 7, 2, 20),
      endDate: DateTime(2025, 7, 2, 23),
      imageUrl: 'https://example.com/jazz.jpg',
      location: const Location(
        name: 'Jazz Lounge',
        lat: 40.758896,
        lng: -73.985130,
      ),
    ),
    Event(
      id: '3',
      title: 'Morning Yoga Session',
      description: 'Start your day with yoga.',
      category: 'Health & Wellness',
      startDate: DateTime(2025, 7, 3, 7),
      endDate: DateTime(2025, 7, 3, 8),
      imageUrl: 'https://example.com/morning-yoga.jpg',
      location: const Location(
        name: 'Park',
        lat: 40.775091,
        lng: -73.960285,
      ),
    ),
  ];

  setUp(() {
    mockGetEventsUseCase = MockGetEventsUseCase();
    mockSearchEventsUseCase = MockSearchEventsUseCase();
    mockFilterEventsByCategoryUseCase = MockFilterEventsByCategoryUseCase();
    mockFavouritesRepository = MockFavouritesRepository();

    bloc = EventsBloc(
      mockGetEventsUseCase,
      mockSearchEventsUseCase,
      mockFilterEventsByCategoryUseCase,
      mockFavouritesRepository,
    );

    when(() => mockFavouritesRepository.getFavouriteIds())
        .thenAnswer((_) async => <String>[]);
  });

  tearDown(() {
    bloc.close();
  });

  group('EventsBloc', () {
    test('initial state is EventsState.initial', () {
      expect(bloc.state, equals(const EventsState.initial()));
    });

    group('LoadEvents', () {
      blocTest<EventsBloc, EventsState>(
        'emits [loading, loaded] when LoadEvents succeeds',
        build: () {
          when(() => mockGetEventsUseCase()).thenAnswer((_) async => tEvents);
          return bloc;
        },
        act: (bloc) => bloc.add(const EventsEvent.loadEvents()),
        expect: () => [
          const EventsState.loading(),
          EventsState.loaded(tEvents),
        ],
        verify: (_) {
          verify(() => mockGetEventsUseCase()).called(1);
        },
      );

      blocTest<EventsBloc, EventsState>(
        'emits [loading, error] when LoadEvents fails',
        build: () {
          when(() => mockGetEventsUseCase())
              .thenThrow(Exception('Failed to load events'));
          return bloc;
        },
        act: (bloc) => bloc.add(const EventsEvent.loadEvents()),
        expect: () => [
          const EventsState.loading(),
          const EventsState.error('Exception: Failed to load events'),
        ],
      );
    });

    group('SearchEvents', () {
      final searchResults = [tEvents[0]];

      blocTest<EventsBloc, EventsState>(
        'emits [loading, loaded] with filtered events on success',
        build: () {
          when(() => mockSearchEventsUseCase('yoga'))
              .thenAnswer((_) async => searchResults);
          return bloc;
        },
        act: (bloc) => bloc.add(const EventsEvent.searchEvents('yoga')),
        expect: () => [
          const EventsState.loading(),
          EventsState.loaded(searchResults),
        ],
        verify: (_) {
          verify(() => mockSearchEventsUseCase('yoga')).called(1);
        },
      );

      blocTest<EventsBloc, EventsState>(
        'emits [loading, error] when SearchEvents fails',
        build: () {
          when(() => mockSearchEventsUseCase('yoga'))
              .thenThrow(Exception('Search failed'));
          return bloc;
        },
        act: (bloc) => bloc.add(const EventsEvent.searchEvents('yoga')),
        expect: () => [
          const EventsState.loading(),
          const EventsState.error('Exception: Search failed'),
        ],
      );
    });

    group('FilterByCategory', () {
      final musicEvents = [tEvents[1]];

      blocTest<EventsBloc, EventsState>(
        'emits [loading, loaded] with filtered events on success',
        build: () {
          when(() => mockFilterEventsByCategoryUseCase('Music'))
              .thenAnswer((_) async => musicEvents);
          return bloc;
        },
        act: (bloc) => bloc.add(const EventsEvent.filterByCategory('Music')),
        expect: () => [
          const EventsState.loading(),
          EventsState.loaded(musicEvents),
        ],
        verify: (_) {
          verify(() => mockFilterEventsByCategoryUseCase('Music')).called(1);
        },
      );

      blocTest<EventsBloc, EventsState>(
        'emits [loading, error] when FilterByCategory fails',
        build: () {
          when(() => mockFilterEventsByCategoryUseCase('Music'))
              .thenThrow(Exception('Filter failed'));
          return bloc;
        },
        act: (bloc) => bloc.add(const EventsEvent.filterByCategory('Music')),
        expect: () => [
          const EventsState.loading(),
          const EventsState.error('Exception: Filter failed'),
        ],
      );
    });

    group('ClearFilters', () {
      blocTest<EventsBloc, EventsState>(
        'emits [loading, loaded] with all events when ClearFilters succeeds',
        build: () {
          when(() => mockGetEventsUseCase()).thenAnswer((_) async => tEvents);
          return bloc;
        },
        act: (bloc) => bloc.add(const EventsEvent.clearFilters()),
        expect: () => [
          const EventsState.loading(),
          EventsState.loaded(tEvents),
        ],
        verify: (_) {
          verify(() => mockGetEventsUseCase()).called(1);
        },
      );
    });

    group('ToggleShowOnlyFavourites', () {
      blocTest<EventsBloc, EventsState>(
        'filters events to show only favourites when toggled on',
        build: () {
          when(() => mockGetEventsUseCase()).thenAnswer((_) async => tEvents);
          when(() => mockFavouritesRepository.getFavouriteIds())
              .thenAnswer((_) async => ['1', '3']);
          return bloc;
        },
        act: (bloc) async {
          bloc.add(const EventsEvent.loadEvents());
          await bloc.stream.firstWhere(
            (state) => state.maybeMap(
              loaded: (_) => true,
              orElse: () => false,
            ),
          );
          bloc.add(const EventsEvent.toggleShowOnlyFavourites());
        },
        skip: 2,
        expect: () => [
          EventsState.loaded(
            [tEvents[0], tEvents[2]],
            showOnlyFavourites: true,
          ),
        ],
      );
    });
  });
}
