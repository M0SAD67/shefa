/// Parses error payloads from the Nest-style API (`error_message`, `extra.errors`).
class ApiErrorMessage {
  ApiErrorMessage._();

  /// Returns all validation / detail messages, deduplicated, separated by newlines.
  static String? tryParseBody(dynamic data) {
    if (data == null) return null;
    if (data is String) {
      final t = data.trim();
      return t.isEmpty ? null : t;
    }
    if (data is! Map) return null;

    final messages = <String>[];
    final seen = <String>{};
    void add(String raw) {
      final t = raw.trim();
      if (t.isEmpty || seen.contains(t)) return;
      seen.add(t);
      messages.add(t);
    }

    final extra = data['extra'];
    if (extra is Map && extra['errors'] is List) {
      for (final err in extra['errors'] as List) {
        if (err is! Map) continue;
        final details = err['details'];
        if (details is! List) continue;
        for (final d in details) {
          if (d is Map && d['message'] != null) {
            add(d['message'].toString());
          }
        }
      }
    }

    if (messages.isNotEmpty) {
      return messages.join('\n');
    }

    for (final key in ['message', 'error_message']) {
      final v = data[key];
      if (v is String && v.trim().isNotEmpty) {
        return v.trim();
      }
    }
    return null;
  }
}
