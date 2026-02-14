import 'package:city_events_explorer/src/features/favourites/domain/usecases/get_favourites.dart';
import 'package:city_events_explorer/src/features/favourites/domain/usecases/toggle_favourite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'favourites_cubit.freezed.dart';

@freezed
class FavouritesState with _$FavouritesState {
  const factory FavouritesState({
    @Default({}) Set<String> favouriteIds,
    @Default(false) bool isLoading,
  }) = _FavouritesState;
}

@injectable
class FavouritesCubit extends Cubit<FavouritesState> {
  FavouritesCubit(
    this._getFavouritesUseCase,
    this._toggleFavouriteUseCase,
  ) : super(const FavouritesState());

  final GetFavouritesUseCase _getFavouritesUseCase;
  final ToggleFavouriteUseCase _toggleFavouriteUseCase;

  Future<void> loadFavourites() async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    try {
      final ids = await _getFavouritesUseCase();
      emit(
        state.copyWith(
          favouriteIds: ids.toSet(),
          isLoading: false,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          isLoading: false,
        ),
      );
    }
  }

  Future<void> toggleFavourite(String eventId) async {
    final updatedIds = Set<String>.from(state.favouriteIds);
    if (updatedIds.contains(eventId)) {
      updatedIds.remove(eventId);
    } else {
      updatedIds.add(eventId);
    }
    emit(state.copyWith(favouriteIds: updatedIds));

    try {
      await _toggleFavouriteUseCase(eventId);
    } on Exception {
      final revertedIds = Set<String>.from(state.favouriteIds);
      if (revertedIds.contains(eventId)) {
        revertedIds.remove(eventId);
      } else {
        revertedIds.add(eventId);
      }
      emit(state.copyWith(favouriteIds: revertedIds));
    }
  }
}
