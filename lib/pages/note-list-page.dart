import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:past_me/locator.dart';
import 'package:past_me/models/note.dart';
import 'package:past_me/pages/note-details-page.dart';
import 'package:past_me/services/base_service.dart';
import 'package:past_me/services/note-service.dart';
import 'package:provider/provider.dart';

import '../components/preview-card.dart';
import 'note-edit-page.dart';

class NoteListPage extends StatefulWidget {
  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  NoteService model = locator<NoteService>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NoteService>(
      builder: (_) => model,
      child: Scaffold(
        backgroundColor: Colors.white70,
        body: Consumer<NoteService>(
          builder: (context, notesModel, child) =>
              notesModel.state == ViewState.Busy
                  ? Center(child: CircularProgressIndicator())
                  : ListView(
                      scrollDirection: Axis.vertical,
                      children: getCards(notesModel.notes)),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).pushNamed('/new'),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  initState() {
    model.loadNotes();
    super.initState();
  }

  List<Widget> getCards(List<Note> entries) {
    return entries
        .map<PreviewCard>((e) => PreviewCard(
              title: e.title,
              body: e.body,
              tapAction: () => viewNoteDetails(e),
            ))
        .toList();
  }

  void viewNoteDetails(note) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NoteDetailsPage(
                  note: note,
                  editAction: () => editNote(note),
                  deleteAction: () => deleteNote(note),
                )));
  }

  void deleteNote(note) {
    model.removeNote(note);
  }

  void editNote(note) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NoteEditPage(note)));
  }
}
