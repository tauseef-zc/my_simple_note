import 'package:note_app/src/features/note/models/note.dart';
import 'package:note_app/src/features/note/repositories/note_repository.dart';

class NoteController {
  final NoteRepository _repository = NoteRepository();

  Future<Note> addNote({
    required String title,
    required String note,
  }) async {
    try {
      final newNote = Note(
        title: title,
        note: note,
        archived: 0,
        trashed: 0,
      );
      final result = await _repository.insert(newNote);
      return result;
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  Future<Note> updateNote({required Note note}) async {
    try {
      final result = await _repository.update(note, 'id', note.id);
      return result;
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  Future<List<Note>> getNotes(String searchQuery) async {
    try {
      final List<Map> notes = await _repository.search(searchQuery, 0, 0);
      return notes.map((noteMap) => _parseNoteFromMap(noteMap)).toList();
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  Future<List<Note>> getArchivedNotes(String searchQuery) async {
    try {
      final List<Map> notes = await _repository.search(searchQuery, 1, 0);
      return notes.map((noteMap) => _parseNoteFromMap(noteMap)).toList();
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  void toggleArchived(Note note) async {
    note.archived = note.archived == 0 ? 1 : 0;
    print(note.toString());
    await _repository.update(note, 'id', note.id);
  }

  Note _parseNoteFromMap(Map noteMap) {
    try {
      return Note(
        id: noteMap['id'] as int,
        title: noteMap['title'] as String,
        note: noteMap['note'] as String,
        archived: (noteMap['archived'] as int?) ?? 0,
        trashed: (noteMap['trashed'] as int?) ?? 0,
        createdAt: DateTime.parse(noteMap['created_at'] as String),
        updatedAt: DateTime.parse(noteMap['updated_at'] as String),
      );
    } catch (e) {
      throw Exception('Failed to parse note from database: $e');
    }
  }
}
