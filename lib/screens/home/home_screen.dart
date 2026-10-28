import 'package:flutter/material.dart';

import 'widgets/home_background.dart';
import 'widgets/home_intro.dart';
import 'widgets/islands_card.dart';

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
