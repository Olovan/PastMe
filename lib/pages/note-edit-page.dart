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
    var theme = Theme.of(context);
    return RaisedButton(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Icon(Icons.arrow_back, color: theme.colorScheme.onSecondary),
      ),
      color: theme.colorScheme.secondary,
      shape: CircleBorder(),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget buildDeleteButton() {
    var theme = Theme.of(context);
    return note.id == null
        ? Container()
        : RaisedButton(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Icon(Icons.delete, color: theme.colorScheme.onSecondary),
            ),
            color: theme.colorScheme.secondary,
            shape: CircleBorder(),
            onPressed: () {
              locator<NoteService>().removeNote(note);
              Navigator.of(context).pop();
            },
          );
  }

  Widget buildBodyField() {
    var theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
          validator: notNullOrEmptyValidator,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.secondary)),
              hintText: "Body",
              contentPadding: EdgeInsets.all(10)),
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
    var theme = Theme.of(context);
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          controller: _actionItemInputController,
          decoration: InputDecoration(
            hintText: "Add action item",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: theme.colorScheme.secondary)),
            fillColor: theme.colorScheme.primary,
            filled: true,
            suffixIcon: addNewActionItemButton(),
          ),
          onChanged: (value) => newActionItem = value,
          onFieldSubmitted: (value) => addActionItem(),
        ));
  }

  Widget addNewActionItemButton() {
    var theme = Theme.of(context);
    return GestureDetector(
        child: Icon(
          Icons.add_circle,
          color: theme.colorScheme.secondary,
        ),
        onTap: addActionItem);
  }

  void addActionItem() {
    note.actionItems = note.actionItems ?? [];
    if (newActionItem.isNotEmpty) {
      note.actionItems.add(NoteActionItem(
          description: newActionItem, parent: note.id, done: false));
      _actionItemInputController.clear();
    }
    setState(() {
      this.note = note;
    });
  }

  Widget buildActionItems() {
    return Expanded(
        child: ListView.builder(
      itemCount: note?.actionItems?.length ?? 0,
      itemBuilder: buildActionItemTile,
    ));
  }

  Widget buildActionItemTile(context, i) {
    var theme = Theme.of(context);
    var actionItem = note.actionItems[i];
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
          color: theme.colorScheme.primary,
          child: GestureDetector(
            onTap: () {
              actionItem.done = !actionItem.done;
              setState(() { });
            },
            child: ListTile(
                leading: Checkbox(
                  value: actionItem.done,
                  onChanged: (bool value) {
                    note.actionItems[i].done = value;
                    setState(() {});
                  },
                ),
                title: Text("${note.actionItems[i].description}")),
          ),
        ),
        key: Key(UniqueKey().toString()),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            note.actionItems[i].done = true;
          } else {
            note.actionItems.removeAt(i);
          }
          setState(() {});
        },
      ),
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
