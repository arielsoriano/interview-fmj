import 'package:city_events_explorer/src/core/injection/injection_container.dart';
import 'package:city_events_explorer/src/core/utils/app_colors.dart';
import 'package:city_events_explorer/src/features/events/presentation/bloc/events_bloc.dart';
import 'package:city_events_explorer/src/features/events/presentation/widgets/event_card.dart';
import 'package:city_events_explorer/src/features/events/presentation/widgets/event_search_bar.dart';
import 'package:city_events_explorer/src/features/events/presentation/widgets/filter_bottom_sheet.dart';
import 'package:city_events_explorer/src/features/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<EventsBloc>()..add(const EventsEvent.loadEvents()),
        ),
        BlocProvider(
          create: (context) => getIt<FavouritesCubit>()..loadFavourites(),
        ),
      ],
      child: const EventsView(),
    );
  }
}

class EventsView extends StatelessWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('City Events'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => FilterBottomSheet.show(context),
            tooltip: 'Filter events',
          ),
        ],
      ),
      body: Column(
        children: [
          const EventSearchBar(),
          BlocBuilder<EventsBloc, EventsState>(
            builder: (context, state) {
              return state.maybeWhen(
                loaded: (events, showOnlyFavourites) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('Favourites'),
                          selected: showOnlyFavourites,
                          onSelected: (_) {
                            context.read<EventsBloc>().add(
                                  const EventsEvent.toggleShowOnlyFavourites(),
                                );
                          },
                          avatar: Icon(
                            showOnlyFavourites
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 18,
                            color: showOnlyFavourites
                                ? AppColors.textOnPrimary
                                : AppColors.favourite,
                          ),
                          selectedColor: AppColors.favourite,
                          showCheckmark: false,
                          labelStyle: TextStyle(
                            color: showOnlyFavourites
                                ? AppColors.textOnPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<EventsBloc, EventsState>(
              builder: (context, state) {
                return state.when(
                  initial: () => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.event_available,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Welcome to City Events',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Discover amazing events happening around you',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  loaded: (events, showOnlyFavourites) {
                    if (events.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 64,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No events found',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your search or filters',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<EventsBloc>().add(
                              const EventsEvent.loadEvents(),
                            );
                      },
                      child: ListView.builder(
                        itemCount: events.length,
                        padding: const EdgeInsets.only(bottom: 16),
                        itemBuilder: (context, index) {
                          return EventCard(event: events[index]);
                        },
                      ),
                    );
                  },
                  error: (message) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading events',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          message,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            context.read<EventsBloc>().add(
                                  const EventsEvent.loadEvents(),
                                );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
