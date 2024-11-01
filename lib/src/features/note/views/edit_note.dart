import 'package:flutter/material.dart';
import 'package:note_app/src/features/note/controllers/note_controller.dart';
import 'package:note_app/src/features/note/views/archive.dart';
import 'package:note_app/src/features/note/views/home.dart';

import '../models/note.dart';

class EditNoteView extends StatefulWidget {
  final Note note;

  const EditNoteView({super.key, required this.note});

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Note note;
  final NoteController controller = NoteController();
  late final TextEditingController _title;
  late final TextEditingController _note;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    note = widget.note;
    _title = TextEditingController(text: note.title);
    _note = TextEditingController(text: note.note);
  }

  @override
  void dispose() {
    _controller.dispose();
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Edit Note"),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      note.title = _title.text;
                      note.note = _note.text;
                      Navigator.pop(context, note);
                    },
                    icon: const Icon(Icons.check)),
                IconButton(
                    onPressed: () {
                      _showBottomMenu(context);
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
            body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: _title,
                      decoration: InputDecoration(
                        hintText: "Title",
                        hintStyle: Theme.of(context).textTheme.headlineSmall,
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      minLines: null,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color),
                    ),
                    Expanded(
                        child: TextField(
                      controller: _note,
                      decoration: InputDecoration(
                          hintText: "Note",
                          hintStyle: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.fontSize),
                          border: InputBorder.none),
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: null,
                      minLines: null,
                    ))
                  ],
                ))));
  }

  void _showBottomMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () => onDelete(context),
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: const Text("Remove Note"),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                titleAlignment: ListTileTitleAlignment.center,
              ),
              ListTile(
                onTap: () => onArchive(context),
                leading: Icon(
                  note.archived == 0 ? Icons.archive : Icons.unarchive,
                  color: Colors.lightBlue,
                ),
                title: note.archived == 0
                    ? const Text("Archive Note")
                    : const Text("Unarchive Note"),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                titleAlignment: ListTileTitleAlignment.center,
                minVerticalPadding: 5,
              )
            ],
          );
        });
  }

  void onDelete(context) {
    controller.deleteNote(note);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const HomePage()));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Note removed!'),
    ));
  }

  void onArchive(context) {
    controller.toggleArchived(note);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const ArchiveView()));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(note.archived == 1
          ? 'Note added to Archive!'
          : "Note removed from Archive!"),
    ));
  }
}
