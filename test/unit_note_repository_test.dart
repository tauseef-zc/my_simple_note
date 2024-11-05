import 'package:flutter_test/flutter_test.dart';
import 'package:note_app/src/features/note/models/note.dart';
import 'package:note_app/src/features/note/repositories/note_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'helper/local_db.dart';

void main() {
  sqfliteFfiInit();

  group("Note Repository Tests", () {
    late NoteRepository repository;

    setUp(() async {
      repository = NoteRepository.withTest(TestDatabase().database);
    });

    Future<Note?> createNote({title, note}) async {
      String noteTitle = title ?? "Test Title";
      String noteContent = note ?? "Test Content";
      return await repository.insert(Note(title: noteTitle, note: noteContent));
    }

    test("Can Create Note", () async {
      Note? note = await createNote(title: "Tauseef");
      expect(note?.title, "Tauseef");
    });

    test("Can Update Note", () async {
      Note? note = await createNote();
      note?.title = "Test Tauseef";
      note?.archived = 1;
      Note? expected =
          note != null ? await repository.update(note, 'id', note.id) : null;

      expect(expected?.title, "Test Tauseef");
      expect(expected?.archived, 1);
    });

    test("Can Find a Note", () async {
      Note? note = await createNote();
      Note? note2 = await repository.find(note?.id ?? 0);
      expect(note?.toJson(), note2?.toJson());
    });

    test("Can Search Note", () async {
      Note? note = await createNote();
      List<Note?> notes = await repository.search("", 0, 0);
      expect(notes.firstWhere((t) => t?.id == note?.id)?.id, note?.id);

      Note? note2 = await createNote(title: "Search");
      notes = await repository.search("Search", 0, 0);
      expect(notes.firstWhere((t) => t?.id == note2?.id)?.id, note2?.id);
    });

    test("Can Delete Note", () async {
      Note? note = await createNote();
      await repository.delete(note!);
      Note? excepted = await repository.find(note.id ?? 0);
      expect(excepted == null, true);
    });

    test("Can Restore Note", () async {
      Note? note = await createNote();
      await repository.delete(note!);
      Note? excepted = await repository.findWithTrashed(note.id ?? 0);
      expect(excepted?.trashed, 1);

      await repository.restore(note);
      Note? restored = await repository.find(note.id ?? 0);
      expect(restored?.trashed, 0);
    });

    test("Can Get Deleted Notes", () async {
      Note? note = await createNote();
      await repository.delete(note!);

      List<Note> notes = await repository.getDeleted();
      expect(notes.firstWhere((t) => t.id == note.id).id, note.id);
    });

    test("Can Forced Delete Notes", () async {
      Note? note = await createNote();

      await repository.delete(note!);
      await repository.forceDelete();

      List<Note> notes = await repository.getDeleted();
      expect(notes.isEmpty, true);
    });
  });
}
