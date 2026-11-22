import 'dart:convert';

final _emailPattern = RegExp(
  r'^[a-zA-Z0-9_%+-]+(?:\.[a-zA-Z0-9_%+-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$',
);

String? validateName(String? value) => value == null || value.trim().isEmpty
    ? 'Introduce tu nombre completo.'
    : null;

String? validateEmail(String? value) =>
    _emailPattern.hasMatch(value?.trim() ?? '')
    ? null
    : 'Introduce un email válido.';

String? validatePassword(String? value, {required bool registering}) {
  if (value == null || value.trim().isEmpty) return 'Introduce tu contraseña.';
  if (!registering) return null;
  if (utf8.encode(value).length > 72) {
    return 'La contraseña supera los 72 bytes.';
  }
  if (value.runes.length < 8 ||
      !RegExp(r'[a-z]').hasMatch(value) ||
      !RegExp(r'[A-Z]').hasMatch(value) ||
      !RegExp(r'[0-9]').hasMatch(value) ||
      !RegExp(r'[^a-zA-Z0-9\s]').hasMatch(value)) {
    return 'Usa 8 caracteres o más, con mayúscula, minúscula, número y símbolo.';
  }
  return null;
}
