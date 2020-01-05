import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:past_me/Events/note_event.dart';
import 'package:past_me/components/circle-raised-button.dart';
import 'package:past_me/components/speed-dial.dart';
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

  _NoteEditPageState();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SpeedDial(
            expandedChildren: buildSpeedDial(),
            child: SafeArea(
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
            )));
  }

  String notNullOrEmptyValidator(String value) {
    if (value.trim().isEmpty) {
      return "Cannot be empty";
    }
    return null;
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
    return Dismissible(
      child: ListTile(
          leading: Checkbox(
            value: actionItem.done,
            onChanged: (bool value) {
              widget.note.actionItems[i].done = value;
              setState(() {});
            },
          ),
          title: Text("${widget.note.actionItems[i].description}")),
      key: Key(actionItem.id.toString()),
      onDismissed: (direction) {
        widget.note.actionItems.remove(actionItem);
      },
      background: Container(color: Colors.red, child: Icon(Icons.delete)),
    );
  }

  List<Widget> buildSpeedDial() {
    if (widget.note.id != null)
      return [
        buildBackButton(),
        buildDeleteButton(),
        buildSaveButton(),
      ];
    else
      return [
        buildBackButton(),
        buildSaveButton(),
      ];
  }

  Widget buildSaveButton() {
    return CircleRaisedButton(
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

  Widget buildDeleteButton() {
    return widget.note.id == null
        ? Container(
            height: 0,
          )
        : CircleRaisedButton(
            child: Icon(Icons.delete),
            onPressed: () {
              locator<NoteService>()
                  .processEvent(NoteDeletedEvent(widget.note));
              Navigator.of(context).pop();
            },
          );
  }

  Widget buildBackButton() {
    return CircleRaisedButton(
      child: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
