import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:past_me/locator.dart';
import 'package:past_me/pages/note-edit-page/note-edit-page.dart';
import 'package:past_me/pages/note-list-page/note-list-page.dart';

import 'models/note.dart';

main() {
  setupLocator();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = buildTheme();
    return MaterialApp(
      title: 'Past Me',
      debugShowCheckedModeBanner: false,
      home: NoteListPage(),
      theme: theme,
      routes: {
        '/home': (BuildContext context) => NoteListPage(),
        '/new': (BuildContext context) => NoteEditPage(Note()),
      },
    );
  }

  ThemeData buildTheme() {
    ThemeData base = ThemeData.light();
    return base.copyWith(
      primaryColor: Color(0xFFC2185B),
      backgroundColor: Color(0xFFF9F9F9),
      accentColor: Color(0xFFC2185B),
    );
  }
}
