import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:past_me/Events/note_event.dart';
import 'package:past_me/components/circle-raised-button.dart';
import 'package:past_me/components/preview-card.dart';
import 'package:past_me/locator.dart';
import 'package:past_me/models/note.dart';
import 'package:past_me/pages/note-edit-page/note-edit-page.dart';
import 'package:past_me/services/note_service.dart';

class NoteListPage extends StatefulWidget {
  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  final NoteService noteService = locator<NoteService>();

  @override
  void initState() {
    noteService.processEvent(NoteListChanged());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: CircleRaisedButton(
        child: Icon(Icons.add),
        onPressed: () => editNote(context, Note()),
      ),
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
        context, MaterialPageRoute(builder: (_) => NoteEditPage(note)));
  }

  @override
  void dispose() {
    noteService.dispose();
    super.dispose();
  }
}
