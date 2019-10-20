import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:past_me/locator.dart';
import 'package:past_me/pages/note-edit-page.dart';

import 'pages/note-list-page.dart';


main() {
  setupLocator();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Past Me',
      color: Colors.red,
      home: NoteListPage(),
      routes: {
        '/home': (BuildContext context) => NoteListPage(),
        '/new': (BuildContext context) => NoteEditPage(),
      },
    );
  }
}
