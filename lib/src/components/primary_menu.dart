import 'package:flutter/material.dart';
import 'package:note_app/src/features/note/views/archive.dart';
import 'package:note_app/src/features/note/views/home.dart';
import 'package:note_app/src/features/note/views/trashed.dart';

class PrimaryMenu extends StatefulWidget {
  const PrimaryMenu({super.key});

  @override
  State<PrimaryMenu> createState() => _PrimaryMenuState();
}

class _PrimaryMenuState extends State<PrimaryMenu> {
  static int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              'My Simple Notes',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontSize: 36),
            ),
          ),
        ),
        ListTile(
          title: const Text('Notes'),
          leading: const Icon(Icons.notes),
          selected: _selectedIndex == 0,
          onTap: () {
            _onItemTapped(0);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
          },
        ),
        ListTile(
          title: const Text('Archived'),
          leading: const Icon(Icons.archive),
          selected: _selectedIndex == 1,
          onTap: () {
            _onItemTapped(1);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const ArchiveView()));
          },
        ),
        ListTile(
          title: const Text('Trash'),
          leading: const Icon(Icons.delete),
          selected: _selectedIndex == 2,
          onTap: () {
            _onItemTapped(2);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const TrashedView()));
          },
        ),
        const SizedBox(
          height: 50,
        )
      ],
    );
  }
}
