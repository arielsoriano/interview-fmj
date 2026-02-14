import 'package:city_events_explorer/src/features/events/domain/entities/event.dart';
import 'package:city_events_explorer/src/features/events/domain/entities/location.dart';
import 'package:city_events_explorer/src/features/events/presentation/widgets/event_card.dart';
import 'package:city_events_explorer/src/features/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockFavouritesCubit extends Mock implements FavouritesCubit {}

void main() {
  late MockFavouritesCubit mockFavouritesCubit;
  late Event testEvent;

  setUp(() {
    mockFavouritesCubit = MockFavouritesCubit();
    testEvent = Event(
      id: '1',
      title: 'Sunset Yoga in the Park',
      description: 'Enjoy a relaxing yoga session at sunset.',
      category: 'Health & Wellness',
      startDate: DateTime(2025, 7, 1, 18),
      endDate: DateTime(2025, 7, 1, 19, 30),
      imageUrl: 'https://picsum.photos/seed/yoga/600/300',
      location: const Location(
        name: 'Central Park',
        lat: 40.785091,
        lng: -73.968285,
      ),
    );

    when(() => mockFavouritesCubit.state).thenReturn(
      const FavouritesState(),
    );
    when(() => mockFavouritesCubit.stream).thenAnswer(
      (_) => const Stream.empty(),
    );
  });

  Widget createWidgetUnderTest({
    Event? event,
    GoRouter? router,
  }) {
    final testRouter = router ??
        GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const Scaffold(),
            ),
            GoRoute(
              path: '/event/:id',
              builder: (context, state) => const Scaffold(),
            ),
          ],
        );

    return MaterialApp.router(
      routerConfig: testRouter,
      builder: (context, child) {
        return BlocProvider<FavouritesCubit>.value(
          value: mockFavouritesCubit,
          child: child,
        );
      },
    );
  }

  testWidgets('displays event title', (tester) async {
    await tester.pumpWidget(
      createWidgetUnderTest(
        router: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => EventCard(event: testEvent),
            ),
            GoRoute(
              path: '/event/:id',
              builder: (context, state) => const Scaffold(),
            ),
          ],
        ),
      ),
    );

    expect(find.text('Sunset Yoga in the Park'), findsOneWidget);
  });

  testWidgets('displays event category', (tester) async {
    await tester.pumpWidget(
      createWidgetUnderTest(
        router: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => EventCard(event: testEvent),
            ),
            GoRoute(
              path: '/event/:id',
              builder: (context, state) => const Scaffold(),
            ),
          ],
        ),
      ),
    );

    expect(find.text('Health & Wellness'), findsOneWidget);
  });

  testWidgets('displays event date', (tester) async {
    await tester.pumpWidget(
      createWidgetUnderTest(
        router: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => EventCard(event: testEvent),
            ),
            GoRoute(
              path: '/event/:id',
              builder: (context, state) => const Scaffold(),
            ),
          ],
        ),
      ),
    );

    expect(find.text('Tue, Jul 1, 2025'), findsOneWidget);
  });

  testWidgets('displays favourite icon', (tester) async {
    await tester.pumpWidget(
      createWidgetUnderTest(
        router: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => EventCard(event: testEvent),
            ),
            GoRoute(
              path: '/event/:id',
              builder: (context, state) => const Scaffold(),
            ),
          ],
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });

  testWidgets(
    'displays filled favourite icon when event is favourite',
    (tester) async {
      when(() => mockFavouritesCubit.state).thenReturn(
        const FavouritesState(favouriteIds: {'1'}),
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          router: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => EventCard(event: testEvent),
              ),
              GoRoute(
                path: '/event/:id',
                builder: (context, state) => const Scaffold(),
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    },
  );

  testWidgets('navigates to detail page on tap', (tester) async {
    var navigationOccurred = false;

    await tester.pumpWidget(
      createWidgetUnderTest(
        router: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => EventCard(event: testEvent),
            ),
            GoRoute(
              path: '/event/:id',
              builder: (context, state) {
                navigationOccurred = true;
                return const Scaffold(
                  body: Center(child: Text('Detail Page')),
                );
              },
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.byType(Card));
    await tester.pumpAndSettle();

    expect(navigationOccurred, isTrue);
    expect(find.text('Detail Page'), findsOneWidget);
  });

  testWidgets('displays location name', (tester) async {
    await tester.pumpWidget(
      createWidgetUnderTest(
        router: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => EventCard(event: testEvent),
            ),
            GoRoute(
              path: '/event/:id',
              builder: (context, state) => const Scaffold(),
            ),
          ],
        ),
      ),
    );

    expect(find.text('Central Park'), findsOneWidget);
  });
}
