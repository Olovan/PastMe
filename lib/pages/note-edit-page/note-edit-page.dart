import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:past_me/Events/note_event.dart';
import 'package:past_me/locator.dart';
import 'package:past_me/models/note.dart';
import 'package:past_me/models/action_item.dart';
import 'package:past_me/pages/note-edit-page/action-item-input.dart';
import 'package:past_me/services/note_service.dart';

class NoteEditPage extends StatefulWidget {
  Note note;

  NoteEditPage(Note target) {
    note = Note.from(target);
    note.actionItems = note.actionItems ?? [];
  }

  @override
  _NoteEditPageState createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  String newActionItem = "";
  TextEditingController _actionItemInputController =
      new TextEditingController();
  FocusNode _focusNode;

  _NoteEditPageState();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // Fix bug with invalid text selection upon clearing text via button
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        persistentFooterButtons: <Widget>[
          buildBackButton(),
          buildDeleteButton(),
          buildSaveButton()
        ],
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  buildBodyField(),
                  Container(height: 20),
                  buildActionItems(),
                  Container(height: 10),
                  ActionItemInput((newItem) {
                    widget.note.actionItems.add(NoteActionItem(
                        description: newItem,
                        parent: widget.note.id,
                        done: false));
                    setState(() => {});
                  }),
                  Container(height: 100),
                ],
              ),
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
    return widget.note.id == null
        ? Container(
            height: 0,
          )
        : RaisedButton(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Icon(Icons.delete, color: theme.colorScheme.onSecondary),
            ),
            color: theme.colorScheme.secondary,
            shape: CircleBorder(),
            onPressed: () {
              locator<NoteService>()
                  .processEvent(NoteDeletedEvent(widget.note));
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
          initialValue: widget.note.body,
          onChanged: (text) => widget.note.body = text,
          keyboardType: TextInputType.multiline,
          maxLines: 5),
    );
  }

  String bodyFieldValidator(String value) {
    return null; // Everything accepted for now
  }

  Widget buildActionItems() {
    var actionItems = <Widget>[];
    for (int i = 0; i < widget.note?.actionItems?.length ?? 0; i++) {
      actionItems.add(buildActionItemTile(context, i));
    }
    return Column(
      children: actionItems,
      mainAxisSize: MainAxisSize.min,
    );
  }

  Widget buildActionItemTile(context, i) {
    var actionItem = widget.note.actionItems[i];
    return ListTile(
        leading: Checkbox(
          value: actionItem.done,
          onChanged: (bool value) {
            widget.note.actionItems[i].done = value;
            setState(() {});
          },
        ),
        title: Text("${widget.note.actionItems[i].description}"));
  }

  Widget buildSaveButton() {
    return FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            widget.note.id != null
                ? locator<NoteService>()
                    .processEvent(NoteUpdatedEvent(widget.note))
                : locator<NoteService>()
                    .processEvent(NoteCreatedEvent(widget.note));
            Navigator.pop(context);
          }
        });
  }

  Widget buildSpeedDial() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          width: 10,
          height: 0,
        ),
        buildBackButton(),
        buildDeleteButton(),
        buildSaveButton(),
      ],
    );
  }
}
