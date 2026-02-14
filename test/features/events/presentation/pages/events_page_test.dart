import 'package:bloc_test/bloc_test.dart';
import 'package:city_events_explorer/src/features/events/domain/entities/event.dart';
import 'package:city_events_explorer/src/features/events/domain/entities/location.dart';
import 'package:city_events_explorer/src/features/events/presentation/bloc/events_bloc.dart';
import 'package:city_events_explorer/src/features/events/presentation/pages/events_page.dart';
import 'package:city_events_explorer/src/features/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockEventsBloc extends MockBloc<EventsEvent, EventsState>
    implements EventsBloc {}

class MockFavouritesCubit extends MockCubit<FavouritesState>
    implements FavouritesCubit {}

void main() {
  late MockEventsBloc mockEventsBloc;
  late MockFavouritesCubit mockFavouritesCubit;

  setUp(() {
    mockEventsBloc = MockEventsBloc();
    mockFavouritesCubit = MockFavouritesCubit();

    when(() => mockFavouritesCubit.state).thenReturn(
      const FavouritesState(),
    );
    when(() => mockFavouritesCubit.loadFavourites()).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<EventsBloc>.value(
                    value: mockEventsBloc,
                  ),
                  BlocProvider<FavouritesCubit>.value(
                    value: mockFavouritesCubit,
                  ),
                ],
                child: const EventsView(),
              );
            },
          ),
          GoRoute(
            path: '/event/:id',
            builder: (context, state) => const Scaffold(),
          ),
        ],
      ),
    );
  }

  group('EventsPage', () {
    testWidgets(
      'displays loading indicator when state is loading',
      (WidgetTester tester) async {
        when(() => mockEventsBloc.state).thenReturn(
          const EventsState.loading(),
        );
        when(() => mockEventsBloc.stream).thenAnswer(
          (_) => Stream.value(const EventsState.loading()),
        );

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'displays list of EventCards when state is loaded',
      (WidgetTester tester) async {
        final testEvents = [
          Event(
            id: '1',
            title: 'Event 1',
            description: 'Description 1',
            category: 'Music',
            startDate: DateTime(2025, 7, 1, 18),
            endDate: DateTime(2025, 7, 1, 20),
            imageUrl: 'https://example.com/1.jpg',
            location: const Location(
              name: 'Location 1',
              lat: 40.785091,
              lng: -73.968285,
            ),
          ),
          Event(
            id: '2',
            title: 'Event 2',
            description: 'Description 2',
            category: 'Sports',
            startDate: DateTime(2025, 7, 2, 10),
            endDate: DateTime(2025, 7, 2, 12),
            imageUrl: 'https://example.com/2.jpg',
            location: const Location(
              name: 'Location 2',
              lat: 40.750580,
              lng: -73.993584,
            ),
          ),
        ];

        when(() => mockEventsBloc.state).thenReturn(
          EventsState.loaded(testEvents),
        );
        when(() => mockEventsBloc.stream).thenAnswer(
          (_) => Stream.value(EventsState.loaded(testEvents)),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(ListView), findsOneWidget);
        expect(find.text('Event 1'), findsOneWidget);
      },
    );

    testWidgets(
      'displays error message when state is error',
      (WidgetTester tester) async {
        const errorMessage = 'Failed to load events';

        when(() => mockEventsBloc.state).thenReturn(
          const EventsState.error(errorMessage),
        );
        when(() => mockEventsBloc.stream).thenAnswer(
          (_) => Stream.value(const EventsState.error(errorMessage)),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('Unable to Load Events'), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('Try Again'), findsOneWidget);
      },
    );

    testWidgets(
      'displays empty state when loaded with no events',
      (WidgetTester tester) async {
        when(() => mockEventsBloc.state).thenReturn(
          const EventsState.loaded([]),
        );
        when(() => mockEventsBloc.stream).thenAnswer(
          (_) => Stream.value(const EventsState.loaded([])),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('No Events Found'), findsOneWidget);
        expect(
          find.text('Try adjusting your search or filters'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.search_off), findsOneWidget);
      },
    );

    testWidgets(
      'displays app bar with title and filter button',
      (WidgetTester tester) async {
        when(() => mockEventsBloc.state).thenReturn(
          const EventsState.initial(),
        );
        when(() => mockEventsBloc.stream).thenAnswer(
          (_) => Stream.value(const EventsState.initial()),
        );

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.text('City Events'), findsOneWidget);
        expect(find.byIcon(Icons.filter_list), findsOneWidget);
      },
    );
  });
}
