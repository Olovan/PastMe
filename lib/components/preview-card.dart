import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:past_me/models/note.dart';

class PreviewCard extends StatelessWidget {
  final double width, height;
  final Function deleteAction;
  final Function editAction;
  final Function tapAction;
  final int titleCutoffLength = 18;
  final double minCardHeight = 40;
  final Note note;

  const PreviewCard(
      {this.note,
      this.deleteAction,
      this.editAction,
      this.tapAction,
      this.height = 200,
      this.width = 350});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapAction,
      child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFDDEEFF), Color(0xFFEEDDFF)], stops: [0, 1]),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(blurRadius: 5, offset: Offset(0, 1), spreadRadius: (-2))
            ],
          ),
          child: buildCardContent(context)),
    );
  }

  Widget buildCardContent(context) {
    return Row(
      children: <Widget>[
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildCardBody(Theme.of(context).textTheme),
              buildCardActionItemSummary()
            ]),
        Spacer(),
        Container(
          child: Icon(Icons.keyboard_arrow_right),
        )
      ],
    );
  }

  Widget buildCardActionItemSummary() {
    return Container(
      margin: EdgeInsets.only(left: 5),
      child: Row(
        children: <Widget>[
          Icon(Icons.check_circle),
          Container(
            width: 10,
          ),
          Text(
              "${note.actionItems.where((ai) => ai.done).toList().length} / ${note.actionItems.length}"),
        ],
      ),
    );
  }

  buildCardBody(TextTheme textTheme) {
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: minCardHeight),
        child: Center(
          child: Text(
            note.body,
            style: textTheme.body1,
          ),
        ));
  }

  String shortenTitle(String text, int maxLength) {
    return text.length > maxLength
        ? text.substring(0, maxLength) + "..."
        : text;
  }
}
