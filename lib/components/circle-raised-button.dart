import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CircleRaisedButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  final double padding;

  CircleRaisedButton({this.child, this.onPressed, this.padding = 16});

  @override
  Widget build(context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0),
      width: padding * 2 + IconTheme.of(context).size,
      child: RaisedButton(
        shape: CircleBorder(),
        elevation: 6, // Same elevation as FloatingActionButton default
        color: Theme.of(context).accentColor,
        textColor: Theme.of(context).colorScheme.onSecondary,
        child: child,
        padding: EdgeInsets.all(padding),
        onPressed: onPressed,
      ),
    );
  }
}
