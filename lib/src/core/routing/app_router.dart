import 'package:city_events_explorer/src/features/events/domain/entities/event.dart';
import 'package:city_events_explorer/src/features/events/presentation/pages/event_detail_page.dart';
import 'package:city_events_explorer/src/features/events/presentation/pages/events_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class AppRoutes {
  static const String events = '/';
  static const String eventDetail = '/event/:id';
  
  static String eventDetailPath(String eventId) => '/event/$eventId';
}

final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.events,
    routes: [
      GoRoute(
        path: AppRoutes.events,
        name: 'events',
        builder: (context, state) => const EventsPage(),
      ),
      GoRoute(
        path: AppRoutes.eventDetail,
        name: 'event-detail',
        builder: (context, state) {
          final event = state.extra! as Event;
          return EventDetailPage(event: event);
        },
      ),
    ],
    errorBuilder: (context, state) => const ErrorPage(),
  );
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Page Not Found'),
      ),
    );
  }
}
