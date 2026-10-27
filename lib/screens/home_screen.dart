import 'package:flutter/material.dart';

import '../widgets/fondo_inicio.dart';
import '../widgets/presentacion_inicio.dart';
import '../widgets/tarjeta_islas.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const FondoInicio(),
        const SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 72),
                PresentacionInicio(),
                SizedBox(height: 32),
                TarjetaIslas(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
