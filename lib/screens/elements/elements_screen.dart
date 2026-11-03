import 'package:flutter/material.dart';

enum ElementCategory {
  nightlife('Ocio nocturno', 'assets/images/canary_night_background.png'),
  gaming('Videojuegos', 'assets/images/denathrius.jpg');

  const ElementCategory(this.label, this.image);
  final String label;
  final String image;
}

class PortfolioElement {
  const PortfolioElement({
    required this.name,
    required this.description,
    required this.category,
  });

  final String name;
  final String description;
  final ElementCategory category;
}

class ElementsScreen extends StatefulWidget {
  const ElementsScreen({super.key});

  @override
  State<ElementsScreen> createState() => _ElementsScreenState();
}

class _ElementsScreenState extends State<ElementsScreen> {
  final List<PortfolioElement> _elements = [];

  Future<void> _deleteAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Borrar todos los elementos'),
        content: Text(
          '¿Quieres borrar los ${_elements.length} elementos de la lista? '
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
    if (!mounted || confirmed != true) return;
    setState(() => _elements.clear());
  }

  Future<void> _addElement() async {
    final result = await showDialog<PortfolioElement>(
      context: context,
      builder: (context) => const _ElementDialog(),
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
          child: _elements.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Todavía no hay elementos. Añade el primero.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: _elements.length,
                  itemBuilder: (context, index) {
                    final element = _elements[index];
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
                                semanticLabel: element.category.label,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    element.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                  Text(
                                    element.category.label,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(element.description),
                                  IconButton(
                                    tooltip: 'Borrar ${element.name}',
                                    onPressed: () => setState(
                                      () => _elements.remove(element),
                                    ),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ElementDialog extends StatefulWidget {
  const _ElementDialog();

  @override
  State<_ElementDialog> createState() => _ElementDialogState();
}

class _ElementDialogState extends State<_ElementDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  ElementCategory _category = ElementCategory.nightlife;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  String? _required(String? value) => value == null || value.trim().isEmpty
      ? 'Este campo es obligatorio'
      : null;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Añadir elemento'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _name,
                  autofocus: true,
                  maxLength: 60,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _description,
                  maxLength: 160,
                  minLines: 2,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Descripción breve',
                  ),
                  validator: _required,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<ElementCategory>(
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  items: ElementCategory.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) _category = value;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.of(context).pop(
              PortfolioElement(
                name: _name.text.trim(),
                description: _description.text.trim(),
                category: _category,
              ),
            );
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
