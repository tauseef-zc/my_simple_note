import 'package:flutter/material.dart';
import '../features/note/models/note.dart';

class TrashCard extends StatelessWidget {
  final Note note;
  final Function(Note) onTrashed;

  const TrashCard({super.key, required this.note, required this.onTrashed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
              Icons.restore_from_trash,
              color: Colors.white,
              size: 48,
            ),
          ),
          onDismissed: (direction) {
            onTrashed(note);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Note restored from trash!'),
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
