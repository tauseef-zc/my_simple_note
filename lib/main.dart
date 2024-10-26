import 'package:flutter/material.dart';
import 'package:note_app/src/features/note/views/home.dart';
import 'package:note_app/src/utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Notes',
      theme: NoteTheme.lightTheme,
      darkTheme: NoteTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
