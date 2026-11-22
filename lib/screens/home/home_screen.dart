import 'package:flutter/material.dart';

import '../../auth/session_controller.dart';
import '../../shared/widgets/message_dialog.dart';
import 'widgets/home_background.dart';
import 'widgets/home_intro.dart';
import 'widgets/islands_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.session});

  final SessionController session;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _busy = false;

  Future<void> _showWelcome() async {
    setState(() => _busy = true);
    final response = await widget.session.welcome();
    if (!mounted) return;
    await showMessage(context, 'Bienvenida', response.message);
    if (!mounted) return;
    if (response.statusCode == 401) {
      await _signOut();
    } else {
      setState(() => _busy = false);
    }
  }

  Future<void> _signOut() async {
    setState(() => _busy = true);
    try {
      await widget.session.signOut();
    } catch (_) {
      if (!mounted) return;
      await showMessage(
        context,
        'Error al cerrar sesión',
        'No se pudo eliminar la sesión guardada.',
      );
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const FondoInicio(),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 72),
                const PresentacionInicio(),
                const SizedBox(height: 32),
                const TarjetaIslas(),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    FilledButton(
                      onPressed: _busy ? null : _showWelcome,
                      child: const Text('Mensaje de bienvenida'),
                    ),
                    OutlinedButton(
                      onPressed: _busy ? null : _signOut,
                      child: const Text('Cerrar sesión'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
