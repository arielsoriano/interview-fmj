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
          final eventId = state.pathParameters['id']!;
          return EventDetailPage(eventId: eventId);
        },
      ),
    ],
    errorBuilder: (context, state) => const ErrorPage(),
  );
}

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Events List - Coming Soon'),
      ),
    );
  }
}

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({required this.eventId, super.key});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Event Detail: $eventId - Coming Soon'),
      ),
    );
  }
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
