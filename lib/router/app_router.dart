import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../auth/session_controller.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/portfolio/portfolio_screen.dart';
import '../screens/elements/elements_screen.dart';
import '../shared/widgets/app_drawer.dart';
import 'app_destination.dart';

GoRouter createAppRouter(SessionController session) => GoRouter(
  initialLocation: AuthScreen.loginPath,
  refreshListenable: session,
  redirect: (context, state) => _sessionRedirect(session, state.uri.path),
  routes: [
    GoRoute(
      path: AuthScreen.loginPath,
      builder: (context, state) => AuthScreen(session: session),
    ),
    GoRoute(
      path: AuthScreen.registerPath,
      builder: (context, state) =>
          AuthScreen(session: session, registering: true),
    ),
    ShellRoute(
      builder: _buildAppShell,
      routes: [
        GoRoute(
          path: AppDestination.elements.path,
          builder: (context, state) => const ElementsScreen(),
        ),
        GoRoute(
          path: AppDestination.home.path,
          builder: (context, state) => HomeScreen(session: session),
        ),
        GoRoute(
          path: AppDestination.portfolio.path,
          builder: (context, state) => const PortfolioScreen(),
        ),
      ],
    ),
  ],
);

String? _sessionRedirect(SessionController session, String path) {
  if (session.isAuthenticated) {
    return path == AuthScreen.loginPath || path == AuthScreen.registerPath
        ? AppDestination.home.path
        : null;
  }
  if (path == AuthScreen.loginPath ||
      (!session.isRestoring && path == AuthScreen.registerPath)) {
    return null;
  }
  return AuthScreen.loginPath;
}

Widget _buildAppShell(BuildContext context, GoRouterState state, Widget child) {
  final destination = AppDestination.fromPath(state.uri.path);

  return Scaffold(
    appBar: AppBar(title: Text(destination.title)),
    drawer: AppDrawer(currentDestination: destination),
    body: child,
  );
}
