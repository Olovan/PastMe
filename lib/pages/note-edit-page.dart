import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:past_me/models/note.dart';
import 'package:past_me/models/action_item.dart';
import 'package:past_me/services/note_service.dart';

import '../locator.dart';

class NoteEditPage extends StatefulWidget {
  final Note note;

  NoteEditPage(this.note);

  @override
  _NoteEditPageState createState() => _NoteEditPageState(this.note);
}

class _NoteEditPageState extends State<NoteEditPage> {
  Note note;
  String newActionItem = "";
  TextEditingController _actionItemInputController =
      new TextEditingController();

  _NoteEditPageState(this.note);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(title: Text('Author Note')),
        backgroundColor: Theme.of(context).backgroundColor,
        floatingActionButton: buildSaveButton(),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                buildBodyField(),
                Container(height: 20),
                buildActionItemInput(),
                Container(height: 10),
                buildActionItems(),
                Container(height: 5),
                Row(
                  children: <Widget>[
                    buildBackButton(),
                    buildDeleteButton(),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
              ],
            ),
          ),
        ));
  }

  String notNullOrEmptyValidator(String value) {
    if (value.trim().isEmpty) {
      return "Cannot be empty";
    }
    return null;
  }

  Widget buildBackButton() {
    return RaisedButton(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Icon(Icons.arrow_back, color: Colors.white),
      ),
      color: Colors.blue,
      shape: CircleBorder(),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget buildDeleteButton() {
    return note.id == null
        ? Container()
        : RaisedButton(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            color: Colors.red,
            shape: CircleBorder(),
            onPressed: () {
              locator<NoteService>().removeNote(note);
              Navigator.of(context).pop();
            },
          );
  }

  Widget buildBodyField() {
    return Container(
      color: Colors.white,
      child: TextFormField(
          validator: notNullOrEmptyValidator,
          decoration: InputDecoration(hintText: "Body"),
          initialValue: note.body,
          onChanged: (text) => note.body = text,
          keyboardType: TextInputType.multiline,
          maxLines: 5),
    );
  }

  String bodyFieldValidator(String value) {
    return null; // Everything accepted for now
  }

  Widget buildActionItemInput() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
            child: TextFormField(
          controller: _actionItemInputController,
          decoration: InputDecoration(
              hintText: "Add action item",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              fillColor: Colors.white,
              filled: true,
              suffixIcon: GestureDetector(
                child: Icon(Icons.add_circle),
                onTap: () {
                  note.actionItems = note.actionItems ?? [];
                  if (newActionItem.isNotEmpty) {
                    note.actionItems.add(NoteActionItem(
                        description: newActionItem,
                        parent: note.id,
                        done: false));
                    _actionItemInputController.clear();
                  }
                  setState(() => {});
                },
              )),
          onChanged: (value) => newActionItem = value,
        )),
      ],
    );
  }

  Widget buildActionItems() {
    return Expanded(
      child: ListView.builder(
          itemCount: note?.actionItems?.length ?? 0,
          itemBuilder: (context, index) {
            return Container(
              child: Dismissible(
                background: Container(
                  color: Colors.green,
                  child: Icon(Icons.check),
                  alignment: Alignment.centerLeft,
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: Icon(Icons.delete_sweep),
                  alignment: Alignment.centerRight,
                ),
                child: Container(
                  color: Colors.white,
                  child: ListTile(
                      title: Text(
                          "${index + 1}. ${note.actionItems[index].description}")),
                ),
                key: Key(UniqueKey().toString()),
                onDismissed: (direction) {
                  note.actionItems.removeAt(index);
                  setState(() {});
                },
              ),
            );
          }),
    );
  }

  Widget buildSaveButton() {
    return FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            locator<NoteService>().addNote(note);
            Navigator.pop(context);
          }
        });
  }
}
