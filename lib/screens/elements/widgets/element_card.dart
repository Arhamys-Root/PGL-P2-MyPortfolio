import 'package:flutter/material.dart';

import '../portfolio_element.dart';

class ElementCard extends StatelessWidget {
  const ElementCard({super.key, required this.element, required this.onDelete});

  final PortfolioElement element;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                element.category.image,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                excludeFromSemantics: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(element.name, style: theme.textTheme.titleMedium),
                  Text(
                    element.category.label,
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(element.description),
                  IconButton(
                    tooltip: 'Borrar ${element.name}',
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
