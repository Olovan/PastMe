
import 'package:flutter/widgets.dart';

class SpeedDial extends StatefulWidget{
  final List<Widget> expandedChildren;

  @override
  _SpeedDialState createState() => _SpeedDialState();

  SpeedDial(this.expandedChildren);
}

class _SpeedDialState extends State<SpeedDial> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return null;
  }

  Widget expandedRow() {
    return null;
  }
}