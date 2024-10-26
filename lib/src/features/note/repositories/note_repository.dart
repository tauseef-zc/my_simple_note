import 'package:note_app/src/features/note/models/note.dart';
import 'package:note_app/src/utils/database/connection.dart';
import 'package:note_app/src/utils/database/query_builder.dart';
import '../../../utils/database/model.dart';

class NoteRepository {
  find(int id) async {
    String query = QueryBuilder()
        .table(Note.getTableName())
        .where('id', '=', id)
        .limit(1)
        .execute();

    List<Map> records = await DatabaseConnection.query(query);
    if (records.isNotEmpty) {
      final noteMap = records.first;
      return Note(
        id: noteMap['id'] as int,
        title: noteMap['title'] as String,
        note: noteMap['note'] as String,
        archived: (noteMap['archived'] as int?) ?? 0,
        trashed: (noteMap['trashed'] as int?) ?? 0,
        createdAt: DateTime.parse(noteMap['created_at'] as String),
        updatedAt: DateTime.parse(noteMap['updated_at'] as String),
      );
    }
    return null;
  }

  insert(Model model) async {
    int id =
        await DatabaseConnection.insert(Note.getTableName(), model.toJson());
    return find(id);
  }

  update(Model model, String whereColumn, dynamic value) async {
    int id = await DatabaseConnection.update(
        Note.getTableName(), model.toJson(), whereColumn, value);
    return find(id);
  }

  search(String search, int archived, int trashed) {
    String query = QueryBuilder()
        .table(Note.getTableName())
        .where('archived', '=', archived)
        .where('trashed', '=', trashed)
        .orWhere('title', 'LIKE', search)
        .orWhere('note', 'LIKE', search)
        .execute();
    return DatabaseConnection.query(query);
  }
}
