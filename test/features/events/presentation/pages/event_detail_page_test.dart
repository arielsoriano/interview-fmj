import 'package:bloc_test/bloc_test.dart';
import 'package:city_events_explorer/src/features/events/domain/entities/event.dart';
import 'package:city_events_explorer/src/features/events/domain/entities/location.dart';
import 'package:city_events_explorer/src/features/events/presentation/pages/event_detail_page.dart';
import 'package:city_events_explorer/src/features/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFavouritesCubit extends MockCubit<FavouritesState>
    implements FavouritesCubit {}

void main() {
  late MockFavouritesCubit mockFavouritesCubit;

  setUp(() {
    mockFavouritesCubit = MockFavouritesCubit();

    when(() => mockFavouritesCubit.state).thenReturn(
      const FavouritesState(),
    );
    when(() => mockFavouritesCubit.toggleFavourite(any()))
        .thenAnswer((_) async {});
  });

  final testEvent = Event(
    id: '1',
    title: 'Sunset Yoga in the Park',
    description: 'Enjoy a relaxing yoga session at sunset.',
    category: 'Health & Wellness',
    startDate: DateTime(2025, 7, 1, 18),
    endDate: DateTime(2025, 7, 1, 19),
    imageUrl: 'https://picsum.photos/seed/yoga/600/300',
    location: const Location(
      name: 'Central Park',
      lat: 40.785091,
      lng: -73.968285,
    ),
  );

  Widget createWidgetUnderTest(Event event) {
    return MaterialApp(
      home: BlocProvider<FavouritesCubit>.value(
        value: mockFavouritesCubit,
        child: EventDetailPage(event: event),
      ),
    );
  }

  group('EventDetailPage', () {
    testWidgets('displays event title', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testEvent));
      await tester.pumpAndSettle();

      expect(find.text(testEvent.title), findsOneWidget);
    });

    testWidgets('displays event category', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testEvent));
      await tester.pumpAndSettle();

      expect(find.text(testEvent.category), findsOneWidget);
    });

    testWidgets('displays event description', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testEvent));
      await tester.pumpAndSettle();

      expect(find.text(testEvent.description), findsOneWidget);
    });

    testWidgets('displays location name', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testEvent));
      await tester.pumpAndSettle();

      expect(find.text(testEvent.location.name), findsOneWidget);
    });

    testWidgets('displays back button', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testEvent));
      await tester.pumpAndSettle();

      expect(
        find.widgetWithIcon(IconButton, Icons.arrow_back),
        findsOneWidget,
      );
    });

    testWidgets('displays favourite button', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testEvent));
      await tester.pumpAndSettle();

      expect(find.byType(IconButton), findsNWidgets(2));
    });

    testWidgets('displays information icons', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testEvent));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
      expect(find.byIcon(Icons.access_time_outlined), findsOneWidget);
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    });

    testWidgets('displays section headers', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testEvent));
      await tester.pumpAndSettle();

      expect(find.text('Date'), findsOneWidget);
      expect(find.text('Time'), findsOneWidget);
      expect(find.text('Location'), findsNWidgets(2));
      expect(find.text('About this event'), findsOneWidget);
    });

    testWidgets('back button pops navigation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => BlocProvider<FavouritesCubit>.value(
                          value: mockFavouritesCubit,
                          child: EventDetailPage(event: testEvent),
                        ),
                      ),
                    );
                  },
                  child: const Text('Go to Detail'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go to Detail'));
      await tester.pumpAndSettle();

      expect(find.byType(EventDetailPage), findsOneWidget);

      await tester.tap(find.widgetWithIcon(IconButton, Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.byType(EventDetailPage), findsNothing);
    });

    testWidgets('displays formatted date', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testEvent));
      await tester.pumpAndSettle();

      expect(find.textContaining('Tuesday'), findsOneWidget);
      expect(find.textContaining('July'), findsOneWidget);
    });

    testWidgets('displays formatted time', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testEvent));
      await tester.pumpAndSettle();

      expect(find.textContaining('6:00 PM'), findsOneWidget);
      expect(find.textContaining('7:00 PM'), findsOneWidget);
    });

    testWidgets('scrolls to show all content', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testEvent));
      await tester.pumpAndSettle();

      expect(find.text('About this event'), findsOneWidget);

      await tester.drag(
        find.byType(CustomScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      expect(find.text('About this event'), findsOneWidget);
    });
  });
}
