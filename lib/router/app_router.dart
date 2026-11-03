import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home/home_screen.dart';
import '../screens/portfolio/portfolio_screen.dart';
import '../screens/elements/elements_screen.dart';
import '../shared/widgets/app_drawer.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        final title = switch (state.uri.path) {
          '/portfolio' => 'Mi portfolio',
          '/elements' => 'Mis elementos',
          _ => 'NOCHE ISLAS',
        };

        return Scaffold(
          appBar: AppBar(title: Text(title)),
          drawer: AppDrawer(currentPath: state.uri.path),
          body: child,
        );
      },
      routes: [
        GoRoute(
          path: '/elements',
          builder: (context, state) => const ElementsScreen(),
        ),
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/portfolio',
          builder: (context, state) => const PortfolioScreen(),
        ),
      ],
    ),
  ],
);
