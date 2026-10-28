import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.currentPath});

  final String currentPath;

  @override
  Widget build(BuildContext context) {
    void navigate(String path) {
      Navigator.of(context).pop();
      context.go(path);
    }

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
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
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Inicio'),
              selected: currentPath == '/',
              onTap: () => navigate('/'),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Mi portfolio'),
              selected: currentPath == '/portfolio',
              onTap: () => navigate('/portfolio'),
            ),
          ],
        ),
      ),
    );
  }
}
