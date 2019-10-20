import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PreviewCard extends StatelessWidget {
  final String body, title;
  final double width, height;
  final Function deleteAction;
  final Function editAction;
  final Function tapAction;
  final int titleCutoffLength = 18;
  final double minCardHeight = 40;

  const PreviewCard(
      {this.body,
      this.title,
      this.deleteAction,
      this.editAction,
      this.tapAction,
      this.height = 200,
      this.width = 350});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapAction,
      child: Card(
          color: Colors.white,
          child: Column(children: <Widget>[
            buildCardTitle(Theme.of(context).textTheme),
            buildCardBody(Theme.of(context).textTheme),
          ])),
    );
  }

  Widget buildCardTitle(TextTheme textTheme) {
    return Row(
      children: <Widget>[
        Container(
            alignment: Alignment.centerLeft,
            child: Text(
              shortenTitle(title, titleCutoffLength),
              style: textTheme.display1,
            )),
        Spacer(),
        conditionallyShowActionIcon(Icons.edit, editAction),
        conditionallyShowActionIcon(Icons.delete, deleteAction),
      ],
    );
  }

  Widget conditionallyShowActionIcon(IconData iconData, Function action) {
    Widget icon = action != null
        ? IconButton(
            icon: Icon(iconData),
            onPressed: action,
          )
        : Container();
    return icon;
  }

  buildCardBody(TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: minCardHeight, maxWidth: width),
              child: Text(
                body,
                style: textTheme.body1,
              )),
        )
      ],
    );
  }

  String shortenTitle(String text, int maxLength) {
    return text.length > maxLength ? text.substring(0, maxLength) + "..." : text;
  }
}
