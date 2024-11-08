import 'package:note_app/src/features/note/models/note.dart';
import 'package:note_app/src/features/note/repositories/note_repository.dart';
import 'package:sqflite/sqflite.dart';

class NoteController {
  late NoteRepository _repository = NoteRepository();

  NoteController();

  NoteController.withTest(Future<Database> database) {
    _repository = NoteRepository.withTest(database);
  }

  Future<Note?> addNote({
    required String title,
    required String note,
  }) async {
    try {
      if (title == '' && note == '') {
        return null;
      }

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
    return await _repository.delete(note);
  }

  Future<Note?> restoreNote(Note note) async {
    return await _repository.restore(note);
  }

  void emptyTrash() async {
    await _repository.forceDelete();
  }
}
