import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/dashboard_page.dart';
import '../pages/logs_page.dart';
import '../pages/analytics_page.dart';
import '../pages/settings_page.dart';
import '../widgets/app_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardPage(),
          ),
        ),
        GoRoute(
          path: '/logs',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LogsPage(),
          ),
        ),
        GoRoute(
          path: '/analytics',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AnalyticsPage(),
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsPage(),
          ),
        ),
      ],
    ),
  ],
);
