import 'package:bloc_test/bloc_test.dart';
import 'package:city_events_explorer/src/features/favourites/domain/usecases/get_favourites.dart';
import 'package:city_events_explorer/src/features/favourites/domain/usecases/toggle_favourite.dart';
import 'package:city_events_explorer/src/features/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFavouritesUseCase extends Mock implements GetFavouritesUseCase {}

class MockToggleFavouriteUseCase extends Mock
    implements ToggleFavouriteUseCase {}

void main() {
  late FavouritesCubit cubit;
  late MockGetFavouritesUseCase mockGetFavouritesUseCase;
  late MockToggleFavouriteUseCase mockToggleFavouriteUseCase;

  setUp(() {
    mockGetFavouritesUseCase = MockGetFavouritesUseCase();
    mockToggleFavouriteUseCase = MockToggleFavouriteUseCase();
    cubit = FavouritesCubit(
      mockGetFavouritesUseCase,
      mockToggleFavouriteUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('FavouritesCubit', () {
    test('initial state has empty favouriteIds', () {
      expect(
        cubit.state,
        equals(const FavouritesState()),
      );
    });

    group('loadFavourites', () {
      final tFavouriteIds = ['1', '3', '5'];

      blocTest<FavouritesCubit, FavouritesState>(
        'loads favourite IDs successfully',
        build: () {
          when(() => mockGetFavouritesUseCase())
              .thenAnswer((_) async => tFavouriteIds);
          return cubit;
        },
        act: (cubit) => cubit.loadFavourites(),
        expect: () => [
          const FavouritesState(isLoading: true),
          FavouritesState(
            favouriteIds: tFavouriteIds.toSet(),
          ),
        ],
        verify: (_) {
          verify(() => mockGetFavouritesUseCase()).called(1);
        },
      );

      blocTest<FavouritesCubit, FavouritesState>(
        'handles error when loading favourites',
        build: () {
          when(() => mockGetFavouritesUseCase())
              .thenThrow(Exception('Failed to load'));
          return cubit;
        },
        act: (cubit) => cubit.loadFavourites(),
        expect: () => [
          const FavouritesState(isLoading: true),
          const FavouritesState(),
        ],
      );
    });

    group('toggleFavourite', () {
      const eventId = '1';

      blocTest<FavouritesCubit, FavouritesState>(
        'adds event ID to favourites when not present',
        build: () {
          when(() => mockToggleFavouriteUseCase(eventId))
              .thenAnswer((_) async {});
          return cubit;
        },
        act: (cubit) => cubit.toggleFavourite(eventId),
        expect: () => [
          const FavouritesState(favouriteIds: {'1'}),
        ],
        verify: (_) {
          verify(() => mockToggleFavouriteUseCase(eventId)).called(1);
        },
      );

      blocTest<FavouritesCubit, FavouritesState>(
        'removes event ID from favourites when present',
        build: () {
          when(() => mockToggleFavouriteUseCase(eventId))
              .thenAnswer((_) async {});
          return cubit;
        },
        seed: () => const FavouritesState(favouriteIds: {'1', '2', '3'}),
        act: (cubit) => cubit.toggleFavourite(eventId),
        expect: () => [
          const FavouritesState(favouriteIds: {'2', '3'}),
        ],
        verify: (_) {
          verify(() => mockToggleFavouriteUseCase(eventId)).called(1);
        },
      );

      blocTest<FavouritesCubit, FavouritesState>(
        'reverts change when toggle fails after adding',
        build: () {
          when(() => mockToggleFavouriteUseCase(eventId))
              .thenThrow(Exception('Failed to toggle'));
          return cubit;
        },
        act: (cubit) => cubit.toggleFavourite(eventId),
        expect: () => [
          const FavouritesState(favouriteIds: {'1'}),
          const FavouritesState(),
        ],
      );

      blocTest<FavouritesCubit, FavouritesState>(
        'reverts change when toggle fails after removing',
        build: () {
          when(() => mockToggleFavouriteUseCase(eventId))
              .thenThrow(Exception('Failed to toggle'));
          return cubit;
        },
        seed: () => const FavouritesState(favouriteIds: {'1', '2'}),
        act: (cubit) => cubit.toggleFavourite(eventId),
        expect: () => [
          const FavouritesState(favouriteIds: {'2'}),
          const FavouritesState(favouriteIds: {'1', '2'}),
        ],
      );
    });
  });
}
