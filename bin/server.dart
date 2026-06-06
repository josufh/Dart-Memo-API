import 'dart:io';

import 'package:google_cloud_firestore/google_cloud_firestore.dart';
import 'package:memo_api/controllers/memo_controller.dart';
import 'package:memo_api/middleware/api_key_auth.dart';
import 'package:memo_api/middleware/cors.dart';
import 'package:memo_api/repositories/firestore_memo_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

void main(List<String> args) async {
  final Firestore firestore = Firestore();
  final FirestoreMemoRepository repository = FirestoreMemoRepository(firestore);
  final MemoController controller = MemoController(repository);
  final Set<String> apiKeys = (Platform.environment['API_KEYS'] ?? '')
      .split(',')
      .map((key) => key.trim())
      .where((key) => key.isNotEmpty)
      .toSet();

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsMiddleware())
      .addMiddleware(apiKeyAuthMiddleware(apiKeys))
      .addHandler(controller.router.call);

  final int port = int.parse(Platform.environment['PORT'] ?? '8080');

  final HttpServer server = await serve(handler, InternetAddress.anyIPv4, port);

  print('Memo API running on port ${server.port}');
}
