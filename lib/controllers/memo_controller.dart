import 'dart:convert';

import 'package:memo_api/models/memo.dart';
import 'package:memo_api/repositories/memo_repository.dart';
import 'package:memo_api/responses/json_response.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class MemoController {
  MemoController(this._repository);

  final MemoRepository _repository;

  Router get router {
    final Router router = Router()
      ..get('/memos', getAll)
      ..get('/memos/<id>', getById)
      ..post('/memos', create)
      ..put('/memos/<id>', update)
      ..delete('/memos/<id>', delete);

    return router;
  }

  Response getAll(Request request) {
    final List<Memo> memos = _repository.getAll();

    return jsonResponse(memos.map((memo) => memo.toJson()).toList());
  }

  Response getById(Request request, String id) {
    final int? memoId = int.tryParse(id);

    if (memoId == null) {
      return jsonResponse({'error': 'Invalid memo id.'}, statusCode: 400);
    }

    final Memo? memo = _repository.getById(memoId);

    if (memo == null) {
      return jsonResponse({'error': 'Memo not found.'}, statusCode: 404);
    }

    return jsonResponse(memo.toJson());
  }

  Future<Response> create(Request request) async {
    final Map<String, dynamic>? body = await _readJson(request);

    if (body == null) {
      return jsonResponse({'error': 'Invalid JSON body.'}, statusCode: 400);
    }

    final Object? title = body['title'];
    final Object? content = body['content'];

    if (title is! String || title.trim().isEmpty) {
      return jsonResponse({'error': 'Title is required.'}, statusCode: 400);
    }

    if (content is! String) {
      return jsonResponse({'error': 'Content is required.'}, statusCode: 400);
    }

    final Memo memo = _repository.create(title, content);

    return jsonResponse(memo.toJson(), statusCode: 201);
  }

  Future<Response> update(Request request, String id) async {
    final int? memoId = int.tryParse(id);

    if (memoId == null) {
      return jsonResponse({'error': 'Invalid memo id.'}, statusCode: 400);
    }

    final Map<String, dynamic>? body = await _readJson(request);

    if (body == null) {
      return jsonResponse({'error': 'Invalid JSON body.'}, statusCode: 400);
    }

    final Object? title = body['title'];
    final Object? content = body['content'];

    if (title is! String || title.trim().isEmpty) {
      return jsonResponse({'error': 'Title is required.'}, statusCode: 400);
    }

    if (content is! String) {
      return jsonResponse({'error': 'Content is required.'}, statusCode: 400);
    }

    final Memo? memo = _repository.update(memoId, title, content);

    if (memo == null) {
      return jsonResponse({'error': 'Memo not found.'}, statusCode: 404);
    }

    return jsonResponse(memo.toJson());
  }

  Response delete(Request request, String id) {
    final int? memoId = int.tryParse(id);

    if (memoId == null) {
      return jsonResponse({'error': 'Invalid memo id.'}, statusCode: 400);
    }

    final bool deleted = _repository.delete(memoId);

    if (!deleted) {
      return jsonResponse({'error': 'Memo not found.'}, statusCode: 404);
    }

    return jsonResponse({'message': 'Memo deleted.'});
  }

  Future<Map<String, dynamic>?> _readJson(Request request) async {
    try {
      final String body = await request.readAsString();

      if (body.trim().isEmpty) {
        return null;
      }

      final Object decoded = jsonDecode(body);

      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      return decoded;
    } catch (_) {
      return null;
    }
  }
}
