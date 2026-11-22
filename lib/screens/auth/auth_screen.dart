import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../auth/auth_validators.dart';
import '../../auth/session_controller.dart';
import '../../shared/widgets/message_dialog.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    required this.session,
    this.registering = false,
  });

  static const loginPath = '/login';
  static const registerPath = '/register';

  final SessionController session;
  final bool registering;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting ||
        widget.session.isRestoring ||
        _form.currentState?.validate() != true) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    final registering = widget.registering;
    final email = _email.text.trim();
    final password = _password.text;
    final response = registering
        ? await widget.session.api.register(_name.text.trim(), email, password)
        : await widget.session.api.login(email, password);
    if (!mounted) return;

    final token = response.token;
    final success = response.isSuccess && (registering || token != null);
    final message = response.isSuccess && !success
        ? 'La API no devolvió un token de sesión.'
        : response.message;
    final title = success
        ? (registering ? 'Registro correcto' : 'Sesión iniciada')
        : (registering ? 'Error de registro' : 'Error de inicio de sesión');

    await showMessage(context, title, message);
    if (!mounted) return;
    if (success && registering) {
      context.go(AuthScreen.loginPath);
      return;
    }
    if (success && token != null) {
      try {
        await widget.session.start(token);
      } catch (_) {
        if (mounted) {
          await showMessage(
            context,
            'Error de almacenamiento',
            'No se pudo guardar la sesión de forma segura.',
          );
        }
      }
    }
    if (mounted) setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final registering = widget.registering;
    final title = registering ? 'Crear cuenta' : 'Iniciar sesión';
    return Scaffold(
      appBar: AppBar(title: const Text('NOCHE ISLAS')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: ListenableBuilder(
                listenable: widget.session,
                builder: (context, child) {
                  final restoring = widget.session.isRestoring;
                  final enabled = !_submitting && !restoring;
                  return AutofillGroup(
                    child: Form(
                      key: _form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 24),
                          if (registering) ...[
                            TextFormField(
                              controller: _name,
                              enabled: enabled,
                              decoration: const InputDecoration(
                                labelText: 'Nombre completo',
                              ),
                              autofillHints: const [AutofillHints.name],
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              validator: validateName,
                            ),
                            const SizedBox(height: 12),
                          ],
                          TextFormField(
                            controller: _email,
                            enabled: enabled,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            autofillHints: const [AutofillHints.email],
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            validator: validateEmail,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _password,
                            enabled: enabled,
                            decoration: const InputDecoration(
                              labelText: 'Contraseña',
                            ),
                            obscureText: true,
                            autocorrect: false,
                            enableSuggestions: false,
                            autofillHints: [
                              registering
                                  ? AutofillHints.newPassword
                                  : AutofillHints.password,
                            ],
                            validator: (value) => validatePassword(
                              value,
                              registering: registering,
                            ),
                            onFieldSubmitted: (_) => _submit(),
                          ),
                          const SizedBox(height: 24),
                          if (restoring) const LinearProgressIndicator(),
                          if (restoring) const Text('Comprobando la sesión…'),
                          if (widget.session.restoreError case final message?)
                            Text(message),
                          FilledButton(
                            onPressed: enabled ? _submit : null,
                            child: Text(
                              registering ? 'Registrar cuenta' : 'Entrar',
                            ),
                          ),
                          TextButton(
                            onPressed: enabled
                                ? () => context.go(
                                    registering
                                        ? AuthScreen.loginPath
                                        : AuthScreen.registerPath,
                                  )
                                : null,
                            child: Text(
                              registering
                                  ? 'Volver a iniciar sesión'
                                  : 'Crear cuenta',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
