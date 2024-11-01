import 'package:flutter/material.dart';
import 'package:note_app/src/features/note/controllers/note_controller.dart';

import '../models/note.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final NoteController controller = NoteController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _note = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Future<Note?> note =
                    controller.addNote(title: _title.text, note: _note.text);
                Navigator.pop(context, note);
              },
              icon: const Icon(Icons.check))
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
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color),
                autofocus: false,
              ),
              Expanded(
                  child: TextField(
                controller: _note,
                decoration: InputDecoration(
                    hintText: "Note",
                    hintStyle: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize:
                            Theme.of(context).textTheme.bodyMedium?.fontSize),
                    border: InputBorder.none),
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: null,
                minLines: null,
              ))
            ],
          )),
    ));
  }
}
