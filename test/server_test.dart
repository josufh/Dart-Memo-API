import 'package:memo_api/middleware/api_key_auth.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  final Uri url = Uri.parse('http://localhost/memos');
  final Handler handler = Pipeline()
      .addMiddleware(apiKeyAuthMiddleware({'test-key'}))
      .addHandler((Request request) => Response.ok('ok'));

  test('rejects requests without an API key', () async {
    final Response response = await handler(Request('GET', url));

    expect(response.statusCode, 401);
    expect(await response.readAsString(), '{"error":"Unauthorized."}');
  });

  test('rejects requests with an invalid API key', () async {
    final Response response = await handler(
      Request('GET', url, headers: {'x-api-key': 'wrong-key'}),
    );

    expect(response.statusCode, 401);
  });

  test('accepts requests with a valid x-api-key header', () async {
    final Response response = await handler(
      Request('GET', url, headers: {'x-api-key': 'test-key'}),
    );

    expect(response.statusCode, 200);
    expect(await response.readAsString(), 'ok');
  });

  test('accepts requests with a valid bearer token', () async {
    final Response response = await handler(
      Request('GET', url, headers: {'authorization': 'Bearer test-key'}),
    );

    expect(response.statusCode, 200);
    expect(await response.readAsString(), 'ok');
  });

  test('requires at least one configured API key', () {
    expect(() => apiKeyAuthMiddleware({}), throwsStateError);
  });
}
