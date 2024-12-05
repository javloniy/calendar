import 'package:calendar/features/data/models/event_model.dart';
import 'package:calendar/features/event/presentation/page/details_event.dart';
import 'package:calendar/features/event/presentation/page/event_page.dart';
import 'package:calendar/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'name_routes.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: Routes.home,
  navigatorKey: rootNavigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: Routes.home,
      name: Routes.home,
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, __) => const HomePage(),
    ),
    GoRoute(
      path: Routes.event,
      name: Routes.event,
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) => EventPage(
        eventModel: state.extra as EventModel?,
      ),
    ),
    GoRoute(
      path: Routes.details,
      name: Routes.details,
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) => DetailsEvent(
        eventModel: state.extra as EventModel,
      ),
    ),
  ],
);
