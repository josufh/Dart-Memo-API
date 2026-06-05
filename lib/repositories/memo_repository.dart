import '../models/memo.dart';

class MemoRepository {
  final List<Memo> _memos = [];
  int _nextId = 1;

  List<Memo> getAll() {
    return _memos;
  }

  Memo? getById(int id) {
    for (final Memo memo in _memos) {
      if (memo.id == id) {
        return memo;
      }
    }
    return null;
  }

  Memo create(String title, String content) {
    final DateTime now = DateTime.now().toUtc();

    final Memo memo = Memo(
      id: _nextId++,
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
    );

    _memos.add(memo);

    return memo;
  }

  Memo? update(int id, String title, String content) {
    final Memo? memo = getById(id)
      ?..title = title
      ..content = content
      ..updatedAt = DateTime.now().toUtc();

    if (memo == null) {
      return null;
    }

    return memo;
  }

  bool delete(int id) {
    final int index = _memos.indexWhere((memo) => memo.id == id);

    if (index == -1) {
      return false;
    }

    _memos.removeAt(index);

    return true;
  }
}
