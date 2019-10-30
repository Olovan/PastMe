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
    return buildStyledCard(
        context: context,
        child: buildCardContent(
          context: context, 
          children: <Widget>[
            buildCardText(Theme.of(context).accentTextTheme),
            Container(height: 10),
            buildCardActionItemSummary(Theme.of(context))
    ]));
  }

  Widget buildStyledCard({child, context}) {
    var theme = Theme.of(context);
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: minCardHeight),
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(blurRadius: 5, offset: Offset(0, 1), spreadRadius: (-2))
            ],
          ),
          child: child,
        ));
  }

  Widget buildCardContent({context, children}) {
    var theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: children),
        Spacer(),
        GestureDetector(
          onTap: tapAction,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration:
                BoxDecoration(border: Border(left: BorderSide(width: 1, color: theme.primaryColor))),
            child: Icon(Icons.edit, color: theme.primaryColor),
          ),
        )
      ],
    );
  }

  Widget buildCardActionItemSummary(ThemeData theme) {
    return Container(
      margin: EdgeInsets.only(left: 5),
      child: Row(
        children: <Widget>[
          Icon(Icons.check_circle, color: theme.primaryColor),
          Container(
            width: 10,
          ),
          Text(
              "${note.actionItems.where((i) => i.done).toList().length} / ${note.actionItems.length}", style: theme.accentTextTheme.body1,),
        ],
      ),
    );
  }

  buildCardText(TextTheme textTheme) {
    return Center(
      child: Text(
        note.body,
        style: textTheme.body1,
      ),
    );
  }

  String shortenText(String text, int maxLength) {
    return text.length > maxLength
        ? text.substring(0, maxLength) + "..."
        : text;
  }
}
