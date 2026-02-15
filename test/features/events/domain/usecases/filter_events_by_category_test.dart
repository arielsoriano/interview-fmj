import 'package:city_events_explorer/src/features/events/domain/entities/event.dart';
import 'package:city_events_explorer/src/features/events/domain/entities/location.dart';
import 'package:city_events_explorer/src/features/events/domain/repositories/i_event_repository.dart';
import 'package:city_events_explorer/src/features/events/domain/usecases/filter_events_by_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEventRepository extends Mock implements IEventRepository {}

void main() {
  late FilterEventsByCategoryUseCase useCase;
  late MockEventRepository mockRepository;

  setUp(() {
    mockRepository = MockEventRepository();
    useCase = FilterEventsByCategoryUseCase(mockRepository);
  });

  group('FilterEventsByCategoryUseCase', () {
    const tCategory = 'Music';
    final tEvents = [
      Event(
        id: '1',
        title: 'Music Festival',
        description: 'A great music festival',
        category: 'Music',
        startDate: DateTime(2025, 7, 1, 18),
        endDate: DateTime(2025, 7, 1, 20),
        imageUrl: 'https://example.com/image1.jpg',
        location: const Location(
          name: 'Concert Hall',
          lat: 40.785091,
          lng: -73.968285,
        ),
      ),
      Event(
        id: '2',
        title: 'Jazz Night',
        description: 'Evening jazz performance',
        category: 'Music',
        startDate: DateTime(2025, 7, 2, 19),
        endDate: DateTime(2025, 7, 2, 22),
        imageUrl: 'https://example.com/image2.jpg',
        location: const Location(
          name: 'Jazz Club',
          lat: 40.750580,
          lng: -73.993584,
        ),
      ),
    ];

    test('should return filtered events from repository', () async {
      when(() => mockRepository.filterByCategory(tCategory))
          .thenAnswer((_) async => tEvents);

      final result = await useCase(tCategory);

      expect(result, equals(tEvents));
      verify(() => mockRepository.filterByCategory(tCategory)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no events match category', () async {
      when(() => mockRepository.filterByCategory('NonExistent'))
          .thenAnswer((_) async => []);

      final result = await useCase('NonExistent');

      expect(result, isEmpty);
      verify(() => mockRepository.filterByCategory('NonExistent')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate error from repository', () async {
      final exception = Exception('Failed to filter events');
      when(() => mockRepository.filterByCategory(tCategory))
          .thenThrow(exception);

      expect(
        () => useCase(tCategory),
        throwsA(equals(exception)),
      );
      verify(() => mockRepository.filterByCategory(tCategory)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
