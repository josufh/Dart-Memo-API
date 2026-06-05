import 'dart:io';

import 'package:memo_api/controllers/memo_controller.dart';
import 'package:memo_api/repositories/memo_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

void main(List<String> args) async {
  final MemoRepository repository = MemoRepository();
  final MemoController controller = MemoController(repository);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(controller.router.call);

  final int port = int.parse(Platform.environment['PORT'] ?? '8080');

  final HttpServer server = await serve(handler, InternetAddress.anyIPv4, port);

  print('Memo API running on port ${server.port}');
}
