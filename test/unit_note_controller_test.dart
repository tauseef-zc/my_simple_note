import 'package:flutter_test/flutter_test.dart';
import 'package:note_app/src/features/note/controllers/note_controller.dart';
import 'package:note_app/src/features/note/models/note.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'helper/local_db.dart';

void main() {
  sqfliteFfiInit();

  group("Note Controller Tests", () {
    late NoteController controller;

    setUp(() async {
      controller = NoteController.withTest(TestDatabase().database);
    });

    test("addNoteTest", () async {
      Note? note =
          await controller.addNote(title: "Tauseef", note: "Test Note");
      expect(note?.title, "Tauseef");
    });

    test("updateNoteTest", () async {
      Note? note =
          await controller.addNote(title: "Tauseef", note: "Test Note");

      if (note != null) {
        note.title = "Hello, Tauseef";
        Note? note2 = await controller.updateNote(note: note);

        expect(note2?.title, "Hello, Tauseef");
      }
    });
  });
}
