import 'package:flutter/material.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        CircleAvatar(
          radius: 48,
          backgroundImage: AssetImage('assets/images/denathrius.jpg'),
        ),
        SizedBox(height: 20),
        Text(
          'Arhamys Josafat Martín Almenara',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Estudiante de Desarrollo de Aplicaciones '
              'Multiplataforma. Este portfolio está '
              'inspirado en World of Warcraft y la creatividad.',
            ),
          ),
        ),
      ],
    );
  }
}
