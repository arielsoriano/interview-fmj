// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/events/data/datasources/local_event_datasource.dart'
    as _i382;
import '../../features/events/data/repositories/event_repository.dart' as _i270;
import '../../features/events/domain/repositories/i_event_repository.dart'
    as _i84;
import '../../features/events/domain/usecases/filter_events_by_category.dart'
    as _i618;
import '../../features/events/domain/usecases/get_events.dart' as _i286;
import '../../features/events/domain/usecases/search_events.dart' as _i996;
import '../../features/events/presentation/bloc/events_bloc.dart' as _i177;
import '../../features/favourites/data/datasources/local_favourites_datasource.dart'
    as _i693;
import '../../features/favourites/data/repositories/favourites_repository.dart'
    as _i1071;
import '../../features/favourites/domain/repositories/i_favourites_repository.dart'
    as _i686;
import '../../features/favourites/domain/usecases/get_favourites.dart' as _i683;
import '../../features/favourites/domain/usecases/toggle_favourite.dart'
    as _i230;
import '../../features/favourites/presentation/cubit/favourites_cubit.dart'
    as _i336;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    await gh.factoryAsync<_i693.LocalFavouritesDatasource>(
      () => _i693.LocalFavouritesDatasource.create(),
      preResolve: true,
    );
    gh.lazySingleton<_i382.LocalEventDatasource>(
        () => _i382.LocalEventDatasource());
    gh.factory<_i84.IEventRepository>(
        () => _i270.EventRepository(gh<_i382.LocalEventDatasource>()));
    gh.factory<_i686.IFavouritesRepository>(() =>
        _i1071.FavouritesRepository(gh<_i693.LocalFavouritesDatasource>()));
    gh.factory<_i618.FilterEventsByCategoryUseCase>(
        () => _i618.FilterEventsByCategoryUseCase(gh<_i84.IEventRepository>()));
    gh.factory<_i286.GetEventsUseCase>(
        () => _i286.GetEventsUseCase(gh<_i84.IEventRepository>()));
    gh.factory<_i996.SearchEventsUseCase>(
        () => _i996.SearchEventsUseCase(gh<_i84.IEventRepository>()));
    gh.factory<_i177.EventsBloc>(() => _i177.EventsBloc(
          gh<_i286.GetEventsUseCase>(),
          gh<_i996.SearchEventsUseCase>(),
          gh<_i618.FilterEventsByCategoryUseCase>(),
          gh<_i686.IFavouritesRepository>(),
        ));
    gh.factory<_i683.GetFavouritesUseCase>(
        () => _i683.GetFavouritesUseCase(gh<_i686.IFavouritesRepository>()));
    gh.factory<_i230.ToggleFavouriteUseCase>(
        () => _i230.ToggleFavouriteUseCase(gh<_i686.IFavouritesRepository>()));
    gh.lazySingleton<_i336.FavouritesCubit>(() => _i336.FavouritesCubit(
          gh<_i683.GetFavouritesUseCase>(),
          gh<_i230.ToggleFavouriteUseCase>(),
        ));
    return this;
  }
}
