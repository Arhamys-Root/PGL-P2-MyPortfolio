import 'package:flutter/material.dart';

class PresentacionInicio extends StatelessWidget {
  const PresentacionInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Chip(label: Text('CANARIAS DE NOCHE')),
        SizedBox(height: 24),
        Text(
          'VIVE LA NOCHE\nEN LAS ISLAS',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Text(
          'Descubre los mejores planes de ocio '
          'y organiza tus clubes favoritos.',
        ),
      ],
    );
  }
}
