import 'package:city_events_explorer/src/features/events/domain/entities/event.dart';
import 'package:city_events_explorer/src/features/events/domain/entities/location.dart';
import 'package:city_events_explorer/src/features/events/domain/repositories/i_event_repository.dart';
import 'package:city_events_explorer/src/features/events/domain/usecases/search_events.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEventRepository extends Mock implements IEventRepository {}

void main() {
  late SearchEventsUseCase useCase;
  late MockEventRepository mockRepository;

  setUp(() {
    mockRepository = MockEventRepository();
    useCase = SearchEventsUseCase(mockRepository);
  });

  group('SearchEventsUseCase', () {
    const tQuery = 'yoga';
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
        title: 'Morning Yoga Class',
        description: 'Start your day with yoga',
        category: 'Health & Wellness',
        startDate: DateTime(2025, 7, 2, 7),
        endDate: DateTime(2025, 7, 2, 8),
        imageUrl: 'https://example.com/yoga2.jpg',
        location: const Location(
          name: 'Yoga Studio',
          lat: 40.750580,
          lng: -73.993584,
        ),
      ),
    ];

    test('should return search results from repository', () async {
      when(() => mockRepository.searchEvents(tQuery))
          .thenAnswer((_) async => tEvents);

      final result = await useCase(tQuery);

      expect(result, equals(tEvents));
      verify(() => mockRepository.searchEvents(tQuery)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no events match query', () async {
      when(() => mockRepository.searchEvents('nonexistent'))
          .thenAnswer((_) async => []);

      final result = await useCase('nonexistent');

      expect(result, isEmpty);
      verify(() => mockRepository.searchEvents('nonexistent')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate error from repository', () async {
      final exception = Exception('Failed to search events');
      when(() => mockRepository.searchEvents(tQuery)).thenThrow(exception);

      expect(
        () => useCase(tQuery),
        throwsA(equals(exception)),
      );
      verify(() => mockRepository.searchEvents(tQuery)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
