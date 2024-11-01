import 'package:flutter/material.dart';
import 'package:note_app/src/features/note/views/edit_note.dart';

import '../features/note/models/note.dart';
import '../helper/Animations.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final Function(Note) onArchived;
  final Function(Note) onDelete;
  final Function(Note) onUpdate;

  const NoteCard(
      {super.key,
      required this.note,
      required this.onArchived,
      required this.onUpdate,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final updatedNote = await Navigator.push(
          context,
          Animations().createRoute(EditNoteView(note: note)),
        );
        if (updatedNote != null) {
          onUpdate(updatedNote);
        }
      },
      child: Dismissible(
          key: Key(note.title),
          background: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.red.shade500,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 48,
            ),
          ),
          secondaryBackground: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade500,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.archive,
              color: Colors.white,
              size: 48,
            ),
          ),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              onArchived(note);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Note archived!'),
              ));
            } else {
              onDelete(note);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Note removed!'),
              ));
            }
          },
          child: Container(
            width: double.maxFinite,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            padding:
                const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                    maxLines: 2,
                    overflow: TextOverflow.visible),
                const SizedBox(height: 10),
                Expanded(
                    child: Text(
                  note.note,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                )),
              ],
            ),
          )),
    );
  }
}
