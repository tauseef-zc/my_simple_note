import 'package:flutter/material.dart';
import 'package:note_app/src/components/primary_menu.dart';
import 'package:note_app/src/components/title_widget.dart';
import 'package:note_app/src/components/note_card.dart';
import 'package:note_app/src/components/search_field.dart';
import '../controllers/note_controller.dart';
import '../models/note.dart';
import 'add_note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final NoteController _noteController = NoteController();
  late Future<List<Note>> _notes;
  late List<Note> _localNotes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _notes = _fetchNotes();
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          actions: [
            Builder(builder: (context) {
              return IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu),
                padding: const EdgeInsets.all(20),
              );
            }),
          ],
        ),
        drawer: const Drawer(child: PrimaryMenu()),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const TitleWidget(),
              const SizedBox(height: 30),
              SearchField(
                search: _searchController,
                onSearch: onNoteSearch,
              ),
              const SizedBox(height: 25),
              generateNoteListing(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Note result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddNoteView()),
            );
            setState(() {
              _localNotes.insert(0, result);
              _notes = Future.value(_localNotes);
            });
          },
          child: const Icon(Icons.edit, color: Colors.white),
        ),
      ),
    );
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
            return const Center(child: Text("No notes available!"));
          } else {
            _localNotes = snapshot.data!;
            return Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _localNotes.length,
                itemBuilder: (context, index) {
                  final note = _localNotes[index];
                  return NoteCard(
                      note: note,
                      onArchived: onNoteArchived,
                      onUpdate: onNoteUpdate);
                },
              ),
            );
          }
        }
        return const Center(child: Text("No notes available!"));
      },
    );
  }

  Future<List<Note>> _fetchNotes() async {
    return await _noteController.getNotes(_searchController.text);
  }

  void onNoteSearch() {
    setState(() {
      _notes = _fetchNotes();
    });
  }

  void onNoteUpdate(Note note) async {
    _noteController.updateNote(note: note);
    int index = _localNotes.indexWhere((n) => n.id == note.id);

    setState(() {
      _localNotes[index] = note;
      _notes = Future.value(_localNotes);
    });
  }

  void onNoteArchived(Note note) {
    _noteController.toggleArchived(note);
    setState(() {
      _localNotes.remove(note);
      _notes = Future.value(_localNotes);
    });
  }
}
