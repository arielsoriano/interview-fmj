import 'package:city_events_explorer/src/features/events/domain/entities/event.dart';
import 'package:city_events_explorer/src/features/events/domain/entities/location.dart';
import 'package:city_events_explorer/src/features/events/domain/repositories/i_event_repository.dart';
import 'package:city_events_explorer/src/features/events/domain/usecases/get_events.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEventRepository extends Mock implements IEventRepository {}

void main() {
  late GetEventsUseCase useCase;
  late MockEventRepository mockRepository;

  setUp(() {
    mockRepository = MockEventRepository();
    useCase = GetEventsUseCase(mockRepository);
  });

  group('GetEventsUseCase', () {
    final tEvents = [
      Event(
        id: '1',
        title: 'Test Event 1',
        description: 'Description 1',
        category: 'Music',
        startDate: DateTime(2025, 7, 1, 18),
        endDate: DateTime(2025, 7, 1, 20),
        imageUrl: 'https://example.com/image1.jpg',
        location: const Location(
          name: 'Central Park',
          lat: 40.785091,
          lng: -73.968285,
        ),
      ),
      Event(
        id: '2',
        title: 'Test Event 2',
        description: 'Description 2',
        category: 'Sports',
        startDate: DateTime(2025, 7, 2, 10),
        endDate: DateTime(2025, 7, 2, 12),
        imageUrl: 'https://example.com/image2.jpg',
        location: const Location(
          name: 'Sports Arena',
          lat: 40.750580,
          lng: -73.993584,
        ),
      ),
    ];

    test('should return list of events from repository', () async {
      when(() => mockRepository.getEvents()).thenAnswer((_) async => tEvents);

      final result = await useCase();

      expect(result, equals(tEvents));
      verify(() => mockRepository.getEvents()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate error from repository', () async {
      final exception = Exception('Failed to load events');
      when(() => mockRepository.getEvents()).thenThrow(exception);

      expect(
        () => useCase(),
        throwsA(equals(exception)),
      );
      verify(() => mockRepository.getEvents()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
