import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/app_destination.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.currentDestination});

  final AppDestination currentDestination;

  void _navigate(BuildContext context, AppDestination destination) {
    final router = GoRouter.of(context);
    Navigator.of(context).pop();
    if (destination != currentDestination) router.go(destination.path);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.nightlife, size: 40),
                  SizedBox(height: 12),
                  Text('NOCHEISLAS'),
                  Text('La noche también es tuya.'),
                ],
              ),
            ),
            for (final destination in AppDestination.values)
              ListTile(
                leading: Icon(destination.icon),
                title: Text(destination.label),
                selected: currentDestination == destination,
                onTap: () => _navigate(context, destination),
              ),
          ],
        ),
      ),
    );
  }
}
