import 'package:flutter/material.dart';
import 'package:note_app/src/features/note/views/archive.dart';
import 'package:note_app/src/features/note/views/home.dart';

class PrimaryMenu extends StatefulWidget {
  const PrimaryMenu({super.key});

  @override
  State<PrimaryMenu> createState() => _PrimaryMenuState();
}

class _PrimaryMenuState extends State<PrimaryMenu> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

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
          child: Text(
            'Smart Notes',
            style: TextStyle(
                height: 1.25,
                fontSize: 32,
                fontWeight: Theme.of(context).textTheme.titleLarge?.fontWeight),
          ),
        ),
        ListTile(
          title: const Text('Notes'),
          selected: _selectedIndex == 0,
          onTap: () {
            _onItemTapped(1);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
          },
        ),
        ListTile(
          title: const Text('Archived'),
          selected: _selectedIndex == 1,
          onTap: () {
            _onItemTapped(1);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const ArchiveView()));
          },
        ),
        ListTile(
          title: const Text('School'),
          selected: _selectedIndex == 2,
          onTap: () {
            _onItemTapped(2);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
