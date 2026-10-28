import 'package:flutter/material.dart';

class FondoInicio extends StatelessWidget {
  const FondoInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/canary_night_background.png', fit: BoxFit.cover),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x660B1023), Color(0xEE0B1023)],
            ),
          ),
        ),
      ],
    );
  }
}
