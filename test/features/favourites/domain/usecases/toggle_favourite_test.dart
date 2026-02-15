import 'package:city_events_explorer/src/features/favourites/domain/repositories/i_favourites_repository.dart';
import 'package:city_events_explorer/src/features/favourites/domain/usecases/toggle_favourite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFavouritesRepository extends Mock implements IFavouritesRepository {}

void main() {
  late ToggleFavouriteUseCase useCase;
  late MockFavouritesRepository mockRepository;

  setUp(() {
    mockRepository = MockFavouritesRepository();
    useCase = ToggleFavouriteUseCase(mockRepository);
  });

  group('ToggleFavouriteUseCase', () {
    const tEventId = '1';

    test('should remove favourite when event is already a favourite', () async {
      when(() => mockRepository.isFavourite(tEventId))
          .thenAnswer((_) async => true);
      when(() => mockRepository.removeFavourite(tEventId))
          .thenAnswer((_) async {});

      await useCase(tEventId);

      verify(() => mockRepository.isFavourite(tEventId)).called(1);
      verify(() => mockRepository.removeFavourite(tEventId)).called(1);
      verifyNever(() => mockRepository.addFavourite(tEventId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should add favourite when event is not a favourite', () async {
      when(() => mockRepository.isFavourite(tEventId))
          .thenAnswer((_) async => false);
      when(() => mockRepository.addFavourite(tEventId))
          .thenAnswer((_) async {});

      await useCase(tEventId);

      verify(() => mockRepository.isFavourite(tEventId)).called(1);
      verify(() => mockRepository.addFavourite(tEventId)).called(1);
      verifyNever(() => mockRepository.removeFavourite(tEventId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate error when checking favourite status fails',
        () async {
      final exception = Exception('Failed to check favourite status');
      when(() => mockRepository.isFavourite(tEventId)).thenThrow(exception);

      expect(
        () => useCase(tEventId),
        throwsA(equals(exception)),
      );
      verify(() => mockRepository.isFavourite(tEventId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate error when adding favourite fails', () async {
      final exception = Exception('Failed to add favourite');
      when(() => mockRepository.isFavourite(tEventId))
          .thenAnswer((_) async => false);
      when(() => mockRepository.addFavourite(tEventId)).thenThrow(exception);

      await expectLater(
        useCase(tEventId),
        throwsA(equals(exception)),
      );
      verify(() => mockRepository.isFavourite(tEventId)).called(1);
      verify(() => mockRepository.addFavourite(tEventId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate error when removing favourite fails', () async {
      final exception = Exception('Failed to remove favourite');
      when(() => mockRepository.isFavourite(tEventId))
          .thenAnswer((_) async => true);
      when(() => mockRepository.removeFavourite(tEventId)).thenThrow(exception);

      await expectLater(
        useCase(tEventId),
        throwsA(equals(exception)),
      );
      verify(() => mockRepository.isFavourite(tEventId)).called(1);
      verify(() => mockRepository.removeFavourite(tEventId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
