import 'package:note_app/src/features/note/models/note.dart';
import 'package:note_app/src/utils/database/db_manager.dart';
import 'package:note_app/src/utils/database/query_builder.dart';
import 'package:sqflite/sqflite.dart';

class NoteRepository {
  late DatabaseManager _db = DatabaseManager.defaultDatabase();

  NoteRepository();

  NoteRepository.withTest(Future<Database> database) {
    _db = DatabaseManager.testDatabase(database);
  }

  Future<Note?> find(int id) async {
    String query = QueryBuilder()
        .table(Note.getTableName())
        .where('id', '=', id)
        .where('trashed', '=', 0)
        .limit(1)
        .execute();

    List<Map> records = await _db.query(query);
    return records.isNotEmpty ? _mapToNote(records.first) : null;
  }

  Future<Note?> findWithTrashed(int id) async {
    String query = QueryBuilder()
        .table(Note.getTableName())
        .where('id', '=', id)
        .limit(1)
        .execute();

    List<Map> records = await _db.query(query);
    return records.isNotEmpty ? _mapToNote(records.first) : null;
  }

  Future<Note?> insert(Note model) async {
    int id = await _db.insert(Note.getTableName(), model.toJson());
    return await find(id);
  }

  Future<Note?> update(Note model, String whereColumn, dynamic value) async {
    await _db.update(Note.getTableName(), model.toJson(), whereColumn, value);
    return await find(value as int);
  }

  Future<Note?> delete(Note model) async {
    model.trashed = 1;
    int id =
        await _db.update(Note.getTableName(), model.toJson(), 'id', model.id);
    return await findWithTrashed(id);
  }

  Future<Note?> restore(Note model) async {
    model.trashed = 0;
    int id =
        await _db.update(Note.getTableName(), model.toJson(), 'id', model.id);
    return await find(id);
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
