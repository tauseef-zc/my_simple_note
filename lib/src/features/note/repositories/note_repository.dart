import 'package:note_app/src/features/note/models/note.dart';
import 'package:note_app/src/utils/database/db_manager.dart';
import 'package:note_app/src/utils/database/query_builder.dart';

import '../../../utils/database/model.dart';

class NoteRepository {
  final DatabaseManager _db;

  NoteRepository(this._db);

  Future<Note?> find(int id) async {
    String query = QueryBuilder()
        .table(Note.getTableName())
        .where('id', '=', id)
        .limit(1)
        .execute();

    List<Map> records = await _db.query(query);
    return records.isNotEmpty ? _mapToNote(records.first) : null;
  }

  Future<Note?> insert(Model model) async {
    int id = await _db.insert(Note.getTableName(), model.toJson());
    return find(id);
  }

  Future<Note?> update(Model model, String whereColumn, dynamic value) async {
    await _db.update(Note.getTableName(), model.toJson(), whereColumn, value);
    return find(value as int);
  }

  Future<void> delete(String whereColumn, dynamic value) async {
    await _db.delete(Note.getTableName(), whereColumn, value);
  }

  Future<int> forceDelete() async {
    return await _db.delete(Note.getTableName(), 'trashed', 1);
  }

  Future<List<Note?>> search(String search, int archived, int trashed) async {
    String query = QueryBuilder()
        .table(Note.getTableName())
        .where('archived', '=', archived)
        .where('trashed', '=', trashed)
        .orWhere('title', 'LIKE', search)
        .orWhere('note', 'LIKE', search)
        .orderBy('updated_at', 'desc')
        .execute();
    List<Map> records = await _db.query(query);
    print(records);
    print(records.map((record) => _mapToNote(record)).toList());
    return records.map((record) => _mapToNote(record)).toList();
  }

  Future<List<Note>> getDeleted() async {
    String query = QueryBuilder()
        .table(Note.getTableName())
        .where('trashed', '=', 1)
        .execute();
    List<Map> records = await _db.query(query);
    return records.map((record) => _mapToNote(record)).toList();
  }

  Note _mapToNote(Map<dynamic, dynamic> record) {
    return Note(
      id: record['id'] as int? ?? 0,
      title: record['title'] as String? ?? '',
      note: record['note'] as String? ?? '',
      archived: (record['archived'] as int?) ?? 0,
      trashed: (record['trashed'] as int?) ?? 0,
      createdAt: DateTime.tryParse(record['created_at'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(record['updated_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
