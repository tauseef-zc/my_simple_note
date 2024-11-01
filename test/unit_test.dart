import 'package:flutter_test/flutter_test.dart';
import 'package:note_app/src/features/note/controllers/note_controller.dart';
import 'package:note_app/src/features/note/models/note.dart';

void main() {
  test("It can create note", () async {
    NoteController controller = NoteController();
    Note? note =
        await controller.addNote(title: "Test Title", note: "Test Note");

    expect(note?.title, "Test Title");
  });
}
