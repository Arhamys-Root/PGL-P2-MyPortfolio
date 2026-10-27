import 'package:flutter/material.dart';

class TarjetaIslas extends StatelessWidget {
  const TarjetaIslas({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TU NOCHE COMIENZA AQUÍ'),
            SizedBox(height: 8),
            Text('Tenerife · Gran Canaria'),
            Text('Lanzarote y mucho más'),
          ],
        ),
      ),
    );
  }
}
