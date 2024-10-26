import 'package:flutter/material.dart';
import 'package:note_app/src/features/note/controllers/note_controller.dart';

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
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                                height: 300,
                                child: Center(
                                  child: ListView(
                                    children: const [
                                      ListTile(
                                        title: Text("Remove Note"),
                                      )
                                    ],
                                  ),
                                ));
                          });
                    },
                    icon: const Icon(Icons.check)),
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
                    TextField(
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
                    )
                  ],
                ))));
  }
}
