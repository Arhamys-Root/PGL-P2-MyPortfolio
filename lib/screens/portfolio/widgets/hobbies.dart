import 'package:flutter/material.dart';

import '../../../data/hobbies.dart';
import 'info_card.dart';

class Hobbies extends StatelessWidget {
  const Hobbies({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 12.0;
          final cardWidth = constraints.maxWidth >= 340
              ? (constraints.maxWidth - spacing) / 2
              : constraints.maxWidth;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (final hobby in hobbies)
                SizedBox(
                  width: cardWidth,
                  child: Tarjeta(
                    icon: hobby.icon,
                    title: hobby.title,
                    subtitle: hobby.subtitle,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
