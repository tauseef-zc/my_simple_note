import 'package:note_app/src/features/note/models/note.dart';
import 'package:note_app/src/features/note/repositories/note_repository.dart';

class NoteController {
  final NoteRepository _repository = NoteRepository();

  Future<Note?> addNote({
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

  Future<Note?> updateNote({required Note note}) async {
    try {
      final result = await _repository.update(note, 'id', note.id);
      return result;
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  Future<Future<List<Note?>>> getNotes(String searchQuery) async {
    try {
      return _repository.search(searchQuery, 0, 0);
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  Future<List<Note?>> getArchivedNotes(String searchQuery) async {
    try {
      return await _repository.search(searchQuery, 1, 0);
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  Future<List<Note>> getDeletedNotes() async {
    try {
      return await _repository.getDeleted();
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  void toggleArchived(Note note) async {
    note.archived = note.archived == 0 ? 1 : 0;
    await _repository.update(note, 'id', note.id);
  }

  Future<Note?> deleteNote(Note note) async {
    note.trashed = 1;
    return await _repository.update(note, 'id', note.id);
  }

  Future<Note?> restoreNote(Note note) async {
    note.trashed = 0;
    return await _repository.update(note, 'id', note.id);
  }

  void emptyTrash() async {
    await _repository.forceDelete();
  }
}
