import 'package:city_events_explorer/src/core/injection/injection_container.dart';
import 'package:city_events_explorer/src/core/utils/app_colors.dart';
import 'package:city_events_explorer/src/core/utils/app_spacing.dart';
import 'package:city_events_explorer/src/features/events/presentation/bloc/events_bloc.dart';
import 'package:city_events_explorer/src/features/events/presentation/widgets/empty_state_widget.dart';
import 'package:city_events_explorer/src/features/events/presentation/widgets/error_state_widget.dart';
import 'package:city_events_explorer/src/features/events/presentation/widgets/event_card.dart';
import 'package:city_events_explorer/src/features/events/presentation/widgets/event_search_bar.dart';
import 'package:city_events_explorer/src/features/events/presentation/widgets/filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<EventsBloc>()..add(const EventsEvent.loadEvents()),
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
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPaddingHorizontal,
                      vertical: AppSpacing.xs,
                    ),
                    child: Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              context.read<EventsBloc>().add(
                                    const EventsEvent
                                        .toggleShowOnlyFavourites(),
                                  );
                            },
                            borderRadius:
                                BorderRadius.circular(AppSpacing.cardRadius),
                            splashColor:
                                AppColors.favourite.withValues(alpha: 0.2),
                            highlightColor:
                                AppColors.favourite.withValues(alpha: 0.1),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: showOnlyFavourites
                                    ? AppColors.favourite
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.cardRadius,
                                ),
                                border: Border.all(
                                  color: showOnlyFavourites
                                      ? AppColors.favourite
                                      : AppColors.border,
                                  width: showOnlyFavourites ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    showOnlyFavourites
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 18,
                                    color: showOnlyFavourites
                                        ? AppColors.textOnPrimary
                                        : AppColors.favourite,
                                  ),
                                  const SizedBox(width: AppSpacing.xxs),
                                  Text(
                                    'Favourites',
                                    style: TextStyle(
                                      color: showOnlyFavourites
                                          ? AppColors.textOnPrimary
                                          : AppColors.textPrimary,
                                      fontWeight: showOnlyFavourites
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                  initial: () => const EmptyStateWidget(
                    icon: Icons.event_available,
                    title: 'Welcome to City Events',
                    message: 'Discover amazing events happening around you',
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  loaded: (events, showOnlyFavourites) {
                    if (events.isEmpty) {
                      return EmptyStateWidget(
                        icon: showOnlyFavourites
                            ? Icons.favorite_border
                            : Icons.search_off,
                        title: showOnlyFavourites
                            ? 'No Favourite Events'
                            : 'No Events Found',
                        message: showOnlyFavourites
                            ? 'Start adding events to your favourites to '
                                'see them here'
                            : 'Try adjusting your search or filters',
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
                  error: (message) => ErrorStateWidget(
                    title: 'Unable to Load Events',
                    message: message,
                    onRetry: () {
                      context.read<EventsBloc>().add(
                            const EventsEvent.loadEvents(),
                          );
                    },
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
