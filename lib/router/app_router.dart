import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home/home_screen.dart';
import '../screens/portfolio/portfolio_screen.dart';
import '../screens/elements/elements_screen.dart';
import '../shared/widgets/app_drawer.dart';
import 'app_destination.dart';

final appRouter = GoRouter(
  initialLocation: AppDestination.home.path,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        final destination = AppDestination.fromPath(state.uri.path);

        return Scaffold(
          appBar: AppBar(title: Text(destination.title)),
          drawer: AppDrawer(currentDestination: destination),
          body: child,
        );
      },
      routes: [
        GoRoute(
          path: AppDestination.elements.path,
          builder: (context, state) => const ElementsScreen(),
        ),
        GoRoute(
          path: AppDestination.home.path,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppDestination.portfolio.path,
          builder: (context, state) => const PortfolioScreen(),
        ),
      ],
    ),
  ],
);
