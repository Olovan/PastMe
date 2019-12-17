import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:past_me/Events/note_event.dart';
import 'package:past_me/locator.dart';
import 'package:past_me/models/note.dart';
import 'package:past_me/services/note_service.dart';

import '../components/preview-card.dart';
import 'note-edit-page.dart';

class NoteListPage extends StatefulWidget {
  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  final NoteService noteService = locator<NoteService>();

  @override
  Widget build(BuildContext context) {
    noteService.processEvent(NoteListChanged());
    return StreamBuilder<List<Note>>(
      stream: noteService.stream,
      builder: (context, snapshot) => snapshot.hasData
          ? buildCardListScreen(context, snapshot.data)
          : Scaffold(body: Center(child: CircularProgressIndicator())),
      initialData: [],
    );
  }

  Widget buildCardListScreen(BuildContext context, List<Note> notes) {
    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        children: getCards(context, notes),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).pushNamed('/new'),
          child: Icon(Icons.add)),
    );
  }

  List<Widget> getCards(BuildContext context, List<Note> entries) {
    return entries
        .map<PreviewCard>((e) => PreviewCard(
              note: e,
              tapAction: () => editNote(context, e),
            ))
        .toList();
  }

  void editNote(BuildContext context, Note note) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NoteEditPage(note)));
  }

  @override
  void dispose() {
    noteService.dispose();
    super.dispose();
  }
}
