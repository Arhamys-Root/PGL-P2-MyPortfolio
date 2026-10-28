import 'package:flutter/material.dart';

import '../../../data/hobbies.dart';
import 'info_card.dart';

class Hobbies extends StatelessWidget {
  const Hobbies({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 180,
      ),
      itemCount: hobbies.length,
      itemBuilder: (context, index) {
        final hobby = hobbies[index];
        return Tarjeta(
          icon: hobby.icon,
          title: hobby.title,
          subtitle: hobby.subtitle,
        );
      },
    );
  }
}
