import 'package:memo_api/responses/json_response.dart';
import 'package:shelf/shelf.dart';

Middleware apiKeyAuthMiddleware(Set<String> validApiKeys) {
  final Set<String> keys = validApiKeys
      .map((key) => key.trim())
      .where((key) => key.isNotEmpty)
      .toSet();

  if (keys.isEmpty) {
    throw StateError('API_KEYS must contain at least one API key.');
  }

  return (Handler innerHandler) {
    return (Request request) {
      final String? apiKey = _readApiKey(request);

      if (apiKey == null || !_containsApiKey(keys, apiKey)) {
        return jsonResponse({'error': 'Unauthorized.'}, statusCode: 401);
      }

      return innerHandler(request);
    };
  };
}

String? _readApiKey(Request request) {
  final String? apiKeyHeader = request.headers['x-api-key'];

  if (apiKeyHeader != null && apiKeyHeader.trim().isNotEmpty) {
    return apiKeyHeader.trim();
  }

  final String? authorization = request.headers['authorization'];

  if (authorization == null) {
    return null;
  }

  final RegExpMatch? match = RegExp(
    r'^Bearer\s+(.+)$',
    caseSensitive: false,
  ).firstMatch(authorization.trim());

  return match?.group(1)?.trim();
}

bool _containsApiKey(Set<String> validApiKeys, String candidate) {
  for (final String validApiKey in validApiKeys) {
    if (_constantTimeEquals(validApiKey, candidate)) {
      return true;
    }
  }

  return false;
}

bool _constantTimeEquals(String left, String right) {
  if (left.length != right.length) {
    return false;
  }

  int difference = 0;

  for (int i = 0; i < left.length; i++) {
    difference |= left.codeUnitAt(i) ^ right.codeUnitAt(i);
  }

  return difference == 0;
}
