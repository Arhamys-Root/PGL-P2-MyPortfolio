import 'package:flutter/material.dart';

import '../portfolio_element.dart';
import 'element_card.dart';

class ElementList extends StatelessWidget {
  const ElementList({
    super.key,
    required this.elements,
    required this.onDelete,
  });

  final List<PortfolioElement> elements;
  final ValueChanged<PortfolioElement> onDelete;

  Widget _buildCard(BuildContext context, int index) {
    final element = elements[index];
    return ElementCard(
      key: ObjectKey(element),
      element: element,
      onDelete: () => onDelete(element),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (elements.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Todav?a no hay elementos. A?ade el primero.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: elements.length,
      itemBuilder: _buildCard,
    );
  }
}
