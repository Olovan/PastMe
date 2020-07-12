import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:past_me/components/circle-raised-button.dart';
import 'package:past_me/components/confirmation-dialog.dart';
import 'package:past_me/components/speed-dial.dart';
import 'package:past_me/locator.dart';
import 'package:past_me/models/Events/note_event.dart';
import 'package:past_me/models/note.dart';
import 'package:past_me/models/action_item.dart';
import 'package:past_me/pages/note-edit-page/action-item-input.dart';
import 'package:past_me/services/note_service.dart';
import 'package:past_me/services/notifications.dart';

class NoteEditPage extends StatefulWidget {
  final Note note;

  NoteEditPage._(this.note); // Private constructor

  // Public factory constructor. This allows us to modify the
  // passed in Note parameter before it becomes immutable.
  factory NoteEditPage(Note target) {
    Note note = Note.from(target);
    note.actionItems = note.actionItems ?? [];
    return NoteEditPage._(note);
  }

  @override
  _NoteEditPageState createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  String newActionItem = "";
  NotificationSystem notificationSystem = locator<NotificationSystem>();

  _NoteEditPageState();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SpeedDial(
            expandedChildren: getSpeedDialEntries(),
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
          color: theme.backgroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
          validator: notNullOrEmptyValidator,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.accentColor)),
              hintText: "Body",
              contentPadding: EdgeInsets.all(10)),
          initialValue: widget.note.body,
          onChanged: (text) => widget.note.body = text,
          keyboardType: TextInputType.multiline,
          maxLines: 3),
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
            actionItem.done = value;
            setState(() {});
          },
        ),
        title: Text("${widget.note.actionItems[i].description}"),
        trailing: actionItem.dueDate != null ? 
          dueDateDisplay(actionItem) :
          createDueDateButton(context, actionItem),
      ),
      key: Key(actionItem.id.toString()),
      onDismissed: (direction) {
        widget.note.actionItems.remove(actionItem);
      },
      background: Container(color: Colors.red, child: Icon(Icons.delete)),
    );
  }

  Widget dueDateDisplay(NoteActionItem actionItem) { 
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Text(Jiffy(actionItem.dueDate).fromNow()),
        IconButton(
          onPressed: () async {
            DateTime dueDate = await showDateTimePicker(context);
            setState(() {
              actionItem.dueDate = dueDate;
            });
          }, 
          icon: Icon(Icons.edit), 
        )
      ]);
  }

  Widget createDueDateButton(context, NoteActionItem actionItem) {
    return IconButton(
          icon: Icon(Icons.alarm), 
          onPressed: () async { 
            DateTime dueDate = await showDateTimePicker(context);
            actionItem.dueDate = dueDate; 
            await notificationSystem.schedule(dueDate, actionItem.description);
            setState((){});
          });
  }

  Future<DateTime> showDateTimePicker(context) async {
    DateTime date;
    TimeOfDay time;
    date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(Duration(days: 365)), lastDate: DateTime.now().add(Duration(days: 365 * 10)));
    if(date != null)
      time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if(date != null && time != null) {
      DateTime dueDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      return dueDate;
    } else {
      return null;
    }
  }

  List<Widget> getSpeedDialEntries() {
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
            onPressed: () async {
              bool confirmDelete = await ConfirmationDialog.show(context,
                  title: "Confirm Deletion",
                  body: "Are you sure you want to delete this note?");
              if (confirmDelete) {
                locator<NoteService>()
                    .processEvent(NoteDeletedEvent(widget.note));
                Navigator.of(context).pop();
              }
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
