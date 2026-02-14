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
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const EventsPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.eventDetail,
        name: 'event-detail',
        pageBuilder: (context, state) {
          final event = state.extra! as Event;
          return CustomTransitionPage(
            key: state.pageKey,
            child: EventDetailPage(event: event),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              const begin = Offset(1, 0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;

              final tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve),
              );

              return SlideTransition(
                position: animation.drive(tween),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          );
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
