import 'package:flutter/material.dart';
import 'package:note_app/src/features/note/views/edit_note.dart';
import '../features/note/models/note.dart';

class ArchiveCard extends StatelessWidget {
  final Note note;
  final Function(Note) onArchived;
  final Function(Note) onUpdate;

  const ArchiveCard(
      {super.key,
      required this.note,
      required this.onArchived,
      required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Note updatedNote = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EditNoteView(note: note)),
        );
        onUpdate(updatedNote);
      },
      child: Dismissible(
          key: Key(note.title),
          direction: DismissDirection.startToEnd,
          background: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade500,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.archive,
              color: Colors.white,
              size: 32,
            ),
          ),
          onDismissed: (direction) {
            onArchived(note);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Note removed from archived'),
            ));
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
                    color: Colors.grey.shade400,
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
