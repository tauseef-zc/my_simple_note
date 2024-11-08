import 'package:flutter/material.dart';
import 'package:note_app/src/components/archive_card.dart';
import 'package:note_app/src/components/primary_menu.dart';
import 'package:note_app/src/components/search_field.dart';

import '../controllers/note_controller.dart';
import '../models/note.dart';

class ArchiveView extends StatefulWidget {
  const ArchiveView({super.key});

  @override
  State<ArchiveView> createState() => _ArchiveViewState();
}

class _ArchiveViewState extends State<ArchiveView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final NoteController _noteController = NoteController();
  late Future<List<Note?>> _notes;
  late List<Note?> _archivedNotes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _notes = _fetchArchiveNotes();
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
            const SizedBox(height: 25),
            SearchField(
              search: _searchController,
              onSearch: () {
                setState(() {
                  _notes = _fetchArchiveNotes();
                });
              },
            ),
            const SizedBox(height: 25),
            generateNoteListing(),
          ],
        ),
      ),
    ));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      title:
          Text("Archive Notes", style: Theme.of(context).textTheme.titleLarge),
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

  FutureBuilder<List<Note?>> generateNoteListing() {
    return FutureBuilder<List<Note?>>(
      future: _notes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text("No notes available!"));
          } else {
            _archivedNotes = snapshot.data!;
            return Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _archivedNotes.length,
                itemBuilder: (context, index) {
                  final note = _archivedNotes[index];
                  return note != null
                      ? ArchiveCard(
                          note: note,
                          onArchived: onNoteArchived,
                          onUpdate: onNoteUpdate)
                      : Container();
                },
              ),
            );
          }
        }
        return const Center(child: Text("No notes available!"));
      },
    );
  }

  Future<List<Note?>> _fetchArchiveNotes() async {
    return await _noteController.getArchivedNotes(_searchController.text);
  }

  void onNoteArchived(Note note) {
    _noteController.toggleArchived(note);
    setState(() {
      _archivedNotes.remove(note);
      _notes = Future.value(_archivedNotes);
    });
  }

  void onNoteUpdate(Note note) {
    _noteController.updateNote(note: note);
    int index = _archivedNotes.indexWhere((n) => n?.id == note.id);

    setState(() {
      _archivedNotes[index] = note;
      _notes = Future.value(_archivedNotes);
    });
  }
}
