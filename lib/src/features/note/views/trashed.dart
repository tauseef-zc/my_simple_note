import 'package:flutter/material.dart';
import 'package:note_app/src/components/primary_menu.dart';
import 'package:note_app/src/components/trash_card.dart';

import '../controllers/note_controller.dart';
import '../models/note.dart';

class TrashedView extends StatefulWidget {
  const TrashedView({super.key});

  @override
  State<TrashedView> createState() => _TrashedViewState();
}

class _TrashedViewState extends State<TrashedView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final NoteController _noteController = NoteController();
  late Future<List<Note>> _notes;
  late List<Note> _trashedNotes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _notes = _fetchTrashedNotes();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: _buildAppBar(context),
      drawer: const Drawer(child: PrimaryMenu()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.width > 600 ? 15 : 25),
            generateNoteListing(),
          ],
        ),
      ),
      floatingActionButton: FutureBuilder<List<Note>>(
        future: _notes,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return _displayFab();
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      title: Text("Trash", style: Theme.of(context).textTheme.titleLarge),
      centerTitle: true,
      actions: [
        Builder(builder: (context) {
          return IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu),
            padding: const EdgeInsets.all(20),
          );
        }),
      ],
    );
  }

  Widget _displayFab() {
    return FloatingActionButton.extended(
        onPressed: _confirmDialog,
        icon: const Icon(
          Icons.delete_forever,
          color: Colors.white,
        ),
        backgroundColor: Colors.red.shade700,
        label: const Text(
          "Empty Trash",
          style: TextStyle(color: Colors.white),
        ));
  }

  FutureBuilder<List<Note>> generateNoteListing() {
    return FutureBuilder<List<Note>>(
      future: _notes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text("Trash is empty!"));
          } else {
            _trashedNotes = snapshot.data!;
            return Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _trashedNotes.length,
                itemBuilder: (context, index) {
                  final note = _trashedNotes[index];
                  return TrashCard(note: note, onTrashed: onNoteTrashed);
                },
              ),
            );
          }
        }
        return const Center(child: Text("No notes available!"));
      },
    );
  }

  void _confirmDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete All'),
            content: const Text('Do you want to clear the trash permanently?'),
            actions: [
              MaterialButton(
                  onPressed: () {
                    _noteController.emptyTrash();
                    setState(() {
                      _trashedNotes.clear();
                      _notes = Future.value(_trashedNotes);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Confirm')),
              MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'))
            ],
          );
        });
  }

  Future<List<Note>> _fetchTrashedNotes() async {
    return await _noteController.getDeletedNotes();
  }

  void onNoteTrashed(Note note) {
    _noteController.restoreNote(note);
    setState(() {
      _trashedNotes.remove(note);
      _notes = Future.value(_trashedNotes);
    });
  }

  void onNoteUpdate(Note note) {
    _noteController.updateNote(note: note);
    int index = _trashedNotes.indexWhere((n) => n.id == note.id);

    setState(() {
      _trashedNotes[index] = note;
      _notes = Future.value(_trashedNotes);
    });
  }
}
