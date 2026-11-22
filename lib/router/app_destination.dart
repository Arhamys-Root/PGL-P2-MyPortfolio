import 'package:flutter/material.dart';

enum AppDestination {
  home('/', 'Inicio', Icons.home_outlined),
  elements('/elements', 'Mis elementos', Icons.format_list_bulleted),
  portfolio('/portfolio', 'Mi portfolio', Icons.person_outline);

  const AppDestination(this.path, this.label, this.icon);

  final String path;
  final String label;
  final IconData icon;

  static AppDestination fromPath(String path) => values.firstWhere(
    (destination) => destination.path == path,
    orElse: () => home,
  );

  String get title => this == home ? 'NOCHE ISLAS' : label;
}
