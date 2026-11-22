import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'auth/auth_api.dart';
import 'auth/session_controller.dart';
import 'auth/session_token_store.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class NocheIslasApp extends StatefulWidget {
  const NocheIslasApp({super.key, this.client});

  final http.Client? client;

  @override
  State<NocheIslasApp> createState() => _NocheIslasAppState();
}

class _NocheIslasAppState extends State<NocheIslasApp> {
  late final _client = widget.client ?? http.Client();
  late final _session = SessionController(
    AuthApi(_client),
    const SessionTokenStore(FlutterSecureStorage()),
  );
  late final _router = createAppRouter(_session);

  @override
  void initState() {
    super.initState();
    unawaited(_session.restore());
  }

  @override
  void dispose() {
    _router.dispose();
    _session.dispose();
    if (widget.client == null) _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NocheIslas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: _router,
    );
  }
}
