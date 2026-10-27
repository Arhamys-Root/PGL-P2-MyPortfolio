import 'package:flutter/material.dart';

import '../widgets/hobbies.dart';
import '../widgets/perfil.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Corte de Pecadores',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          const TabBar(
            tabs: [
              Tab(text: 'Perfil'),
              Tab(text: 'Hobbies'),
            ],
          ),
          Expanded(child: const TabBarView(children: [Perfil(), Hobbies()])),
        ],
      ),
    );
  }
}
