import 'package:flutter/material.dart';

import 'portfolio_element.dart';
import 'widgets/element_dialog.dart';
import 'widgets/element_list.dart';

class ElementsScreen extends StatefulWidget {
  const ElementsScreen({super.key});

  @override
  State<ElementsScreen> createState() => _ElementsScreenState();
}

class _ElementsScreenState extends State<ElementsScreen> {
  final List<PortfolioElement> _elements = [];

  void _deleteElement(PortfolioElement element) {
    setState(() => _elements.remove(element));
  }

  Future<bool?> _confirmDeleteAll(int count) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Borrar todos los elementos'),
        content: Text(
          '¿Quieres borrar los $count elementos de la lista? '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirmar borrado'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAll() async {
    final confirmed = await _confirmDeleteAll(_elements.length);
    if (!mounted || confirmed != true) return;
    setState(() => _elements.clear());
  }

  Future<void> _addElement() async {
    final result = await showDialog<PortfolioElement>(
      context: context,
      builder: (context) => const ElementDialog(),
    );
    if (!mounted || result == null) return;
    setState(() => _elements.add(result));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Total de elementos: ${_elements.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              FilledButton.icon(
                onPressed: _addElement,
                icon: const Icon(Icons.add),
                label: const Text('Añadir elemento'),
              ),
              OutlinedButton.icon(
                onPressed: _elements.isEmpty ? null : _deleteAll,
                icon: const Icon(Icons.delete_sweep_outlined),
                label: const Text('Borrar todos'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ElementList(elements: _elements, onDelete: _deleteElement),
        ),
      ],
    );
  }
}
