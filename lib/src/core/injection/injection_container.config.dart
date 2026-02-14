// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/events/domain/repositories/i_event_repository.dart'
    as _i84;
import '../../features/events/domain/usecases/filter_events_by_category.dart'
    as _i618;
import '../../features/events/domain/usecases/get_events.dart' as _i286;
import '../../features/events/domain/usecases/search_events.dart' as _i996;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i618.FilterEventsByCategoryUseCase>(
        () => _i618.FilterEventsByCategoryUseCase(gh<_i84.IEventRepository>()));
    gh.factory<_i286.GetEventsUseCase>(
        () => _i286.GetEventsUseCase(gh<_i84.IEventRepository>()));
    gh.factory<_i996.SearchEventsUseCase>(
        () => _i996.SearchEventsUseCase(gh<_i84.IEventRepository>()));
    return this;
  }
}
