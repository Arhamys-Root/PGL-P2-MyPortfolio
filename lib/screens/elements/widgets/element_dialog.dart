import 'package:flutter/material.dart';

import '../portfolio_element.dart';

class ElementDialog extends StatefulWidget {
  const ElementDialog({super.key});

  @override
  State<ElementDialog> createState() => _ElementDialogState();
}

class _ElementDialogState extends State<ElementDialog> {
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

  String? _validateRequired(String? value) =>
      value == null || value.trim().isEmpty
      ? 'Este campo es obligatorio'
      : null;

  void _save() {
    if (_formKey.currentState?.validate() != true) return;
    Navigator.of(context).pop<PortfolioElement>(
      PortfolioElement(
        name: _name.text.trim(),
        description: _description.text.trim(),
        category: _category,
      ),
    );
  }

  void _selectCategory(ElementCategory? category) {
    if (category != null) _category = category;
  }

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
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 60,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: _validateRequired,
                ),
                TextFormField(
                  controller: _description,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 160,
                  minLines: 2,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Descripción breve',
                  ),
                  validator: _validateRequired,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<ElementCategory>(
                  initialValue: ElementCategory.nightlife,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  items: ElementCategory.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.label),
                        ),
                      )
                      .toList(),
                  onChanged: _selectCategory,
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
        FilledButton(onPressed: _save, child: const Text('Guardar')),
      ],
    );
  }
}
