import 'package:flutter/material.dart';

import '../../../shared/app_images.dart';

class FondoInicio extends StatelessWidget {
  const FondoInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppImages.canaryNight,
          fit: BoxFit.cover,
          excludeFromSemantics: true,
        ),
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
