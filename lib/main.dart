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
      backgroundColor: Color(0xFFF9F9F9),
      primaryColor: Color(0xFFFAFAFA),
      primaryColorLight: Color(0xFFFFFFFF),
      primaryColorDark: Color(0xC7C7C7C7),
      accentColor: Color(0xFFC2185B),
      colorScheme: base.colorScheme.copyWith(
        primary: Color(0xFFFAFAFA),
        primaryVariant: Color(0xFFFFFFFF),
        onPrimary: Color(0xFF000000),
        secondary: Color(0xFFC2185B),
        secondaryVariant: Color(0xFF8C0032),
        onSecondary: Color(0xFFFFFFFF)
      )
    );
  }
}
