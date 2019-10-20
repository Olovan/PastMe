import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:past_me/models/note.dart';
import 'package:past_me/services/note-service.dart';

import '../locator.dart';

class NoteEditPage extends StatefulWidget {
  Note newNote;

  NoteEditPage([newNote]) {
    if (newNote != null) {
      this.newNote = newNote;
    } else {
      this.newNote = Note(title: "", body: "");
    }
  }

  @override
  _NoteEditPageState createState() => _NoteEditPageState(this.newNote);
}

class _NoteEditPageState extends State<NoteEditPage> {
  Note newNote;

  _NoteEditPageState(this.newNote);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Author Note')),
        backgroundColor: Colors.white70,
        floatingActionButton: buildSaveButton(newNote),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
              ),
              buildTitleField(newNote),
              buildBodyField(newNote),
              Padding(
                padding: EdgeInsets.all(10),
              ),
            ],
          ),
        ));
  }

  Widget buildTitleField(newNote) {
    return Container(
      color: Colors.white,
      child: TextFormField(
        decoration: InputDecoration(hintText: "Title"),
        initialValue: newNote.title,
        onChanged: (text) => newNote.title = text,
        validator: titleFieldValidator,
      ),
    );
  }

  String titleFieldValidator(String value) {
    if (value.trim().isEmpty) {
      return "Please enter a title";
    }
    return null;
  }

  Widget buildBodyField(newNote) {
    return Container(
      color: Colors.white,
      child: TextFormField(
          decoration: InputDecoration(hintText: "Body"),
          initialValue: newNote.body,
          onChanged: (text) => newNote.body = text,
          keyboardType: TextInputType.multiline,
          maxLines: 10),
    );
  }

  String bodyFieldValidator(String value) {
    return null; // Everything accepted for now
  }

  Widget buildSaveButton(newNote) {
    return FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            locator<NoteService>().addNote(newNote);
            Navigator.pop(context);
          }
        });
  }

}
