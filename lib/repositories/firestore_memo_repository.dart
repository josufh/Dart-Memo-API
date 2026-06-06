import 'package:google_cloud_firestore/google_cloud_firestore.dart';
import 'package:memo_api/models/memo.dart';

class FirestoreMemoRepository {
  final Firestore _firestore;

  FirestoreMemoRepository(this._firestore);

  CollectionReference get _collection {
    return _firestore.collection('memos');
  }

  Future<List<Memo>> getAll() async {
    final snapshot = await _collection.get();

    final List<Memo> memos = <Memo>[];

    for (final document in snapshot.docs) {
      final data = document.data();

      if (data == null) {
        continue;
      }

      memos.add(_fromDocument(document.id, data));
    }

    return memos;
  }

  Future<Memo?> getById(String id) async {
    final snapshot = await _collection.doc(id).get();

    if (!snapshot.exists) {
      return null;
    }

    final data = snapshot.data();

    if (data == null) {
      return null;
    }

    return _fromDocument(snapshot.id, data);
  }

  Future<Memo> create(String title, String content) async {
    final now = DateTime.now().toUtc();

    final data = {
      'title': title,
      'content': content,
      'createdAt': now,
      'updatedAt': now,
    };

    final documentReference = await _collection.add(data);
    final snapshot = await documentReference.get();

    return _fromDocument(snapshot.id, snapshot.data());
  }

  Future<Memo?> update(String id, String title, String content) async {
    final documentReference = _collection.doc(id);
    final snapshot = await documentReference.get();

    if (!snapshot.exists) {
      return null;
    }

    await documentReference.update({
      'title': title,
      'content': content,
      'updatedAt': DateTime.now().toUtc(),
    });

    final updatedSnapshot = await documentReference.get();
    final data = updatedSnapshot.data();

    if (data == null) {
      return null;
    }

    return _fromDocument(updatedSnapshot.id, data);
  }

  Future<bool> delete(String id) async {
    final documentReference = _collection.doc(id);
    final snapshot = await documentReference.get();

    if (!snapshot.exists) {
      return false;
    }

    await documentReference.delete();

    return true;
  }

  Memo _fromDocument(String id, Map<String, dynamic> data) {
    return Memo(
      id: id,
      title: _readString(data, 'title'),
      content: _readString(data, 'content'),
      createdAt: _readDateTime(data, 'createdAt'),
      updatedAt: _readDateTime(data, 'updatedAt'),
    );
  }

  String _readString(Map<String, dynamic> data, String key) {
    final value = data[key];

    if (value is String) {
      return value;
    }

    return '';
  }

  DateTime _readDateTime(Map<String, dynamic> data, String key) {
    final value = data[key];

    if (value is DateTime) {
      return value.toUtc();
    }

    if (value is String) {
      return DateTime.parse(value).toUtc();
    }

    return DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true);
  }
}
