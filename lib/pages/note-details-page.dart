import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:past_me/models/note.dart';

class NoteDetailsPage extends StatelessWidget {
  final Note note;
  final Widget emptyWidget = Container();
  final Function editAction, deleteAction;

  NoteDetailsPage({@required this.note, this.editAction, this.deleteAction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 10),
            buildBody(context),
            Container(height: 20),
            buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  Widget buildBody(context) {
    return Container(
        constraints: BoxConstraints(minHeight: 100),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        color: Colors.white,
        child: Text(note.body));
  }

  Widget buildBottomButtons(context) {
    return Row(
      children: <Widget>[
        Spacer(),
        conditionallyShowButton(Icons.delete, () {
          deleteAction();
          Navigator.pop(context);
        }, heroTag: 'deleteButton', color: Colors.redAccent),
        Container(width: 20),
        conditionallyShowButton(Icons.edit, editAction,
            heroTag: 'editButton', color: Colors.blue),
        Container(width: 5),
      ],
    );
  }

  Widget conditionallyShowButton(IconData icon, action,
      {String heroTag = '', Color color = Colors.blue}) {
    if (action != null)
      return FloatingActionButton(
        backgroundColor: color,
        child: Icon(icon),
        onPressed: action,
        heroTag: heroTag,
      );
    else
      return Container();
  }

  Widget fillHorizontalSpace({Widget before, Widget child, Widget after}) {
    before = before == null ? Container() : before;
    after = after == null ? Container() : after;

    return Row(
      children: <Widget>[before, Expanded(child: child), after],
    );
  }
}
