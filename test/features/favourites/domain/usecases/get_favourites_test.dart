import 'package:city_events_explorer/src/features/favourites/domain/repositories/i_favourites_repository.dart';
import 'package:city_events_explorer/src/features/favourites/domain/usecases/get_favourites.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFavouritesRepository extends Mock implements IFavouritesRepository {}

void main() {
  late GetFavouritesUseCase useCase;
  late MockFavouritesRepository mockRepository;

  setUp(() {
    mockRepository = MockFavouritesRepository();
    useCase = GetFavouritesUseCase(mockRepository);
  });

  group('GetFavouritesUseCase', () {
    final tFavouriteIds = ['1', '2', '3'];

    test('should return list of favourite IDs from repository', () async {
      when(() => mockRepository.getFavouriteIds())
          .thenAnswer((_) async => tFavouriteIds);

      final result = await useCase();

      expect(result, equals(tFavouriteIds));
      verify(() => mockRepository.getFavouriteIds()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no favourites exist', () async {
      when(() => mockRepository.getFavouriteIds())
          .thenAnswer((_) async => []);

      final result = await useCase();

      expect(result, isEmpty);
      verify(() => mockRepository.getFavouriteIds()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate error from repository', () async {
      final exception = Exception('Failed to load favourites');
      when(() => mockRepository.getFavouriteIds()).thenThrow(exception);

      expect(
        () => useCase(),
        throwsA(equals(exception)),
      );
      verify(() => mockRepository.getFavouriteIds()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
