import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:past_me/locator.dart';
import 'package:past_me/models/note.dart';
import 'package:past_me/services/base_service.dart';
import 'package:past_me/services/note_service.dart';
import 'package:provider/provider.dart';

import '../components/preview-card.dart';
import 'note-edit-page.dart';

class NoteListPage extends StatelessWidget {

  final NoteService model = locator<NoteService>();

  @override
  Widget build(BuildContext context) {
    model.loadNotes();

    return ChangeNotifierProvider<NoteService>(
      builder: (_) => model,
      child: Scaffold(
        body: Consumer<NoteService>(
          builder: (context, notesModel, child) =>
              notesModel.state == ViewState.Busy
                  ? Center(child: CircularProgressIndicator())
                  : ListView(
                      scrollDirection: Axis.vertical,
                      children: getCards(context, notesModel.notes)),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).pushNamed('/new'),
          child: Icon(Icons.add),
        ),
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

  void deleteNote(Note note) {
    model.removeNote(note);
  }

  void editNote(BuildContext context, Note note) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NoteEditPage(note)));
  }
}