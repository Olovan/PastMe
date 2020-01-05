import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:past_me/components/circle-raised-button.dart';

class SpeedDial extends StatefulWidget {
  final List<Widget> expandedChildren;
  final Widget child;
  final double spacing;

  @override
  _SpeedDialState createState() => _SpeedDialState();

  SpeedDial(
      {this.expandedChildren,
      this.spacing = 60,
      this.child = const SizedBox()});
}

class _SpeedDialState extends State<SpeedDial>
    with SingleTickerProviderStateMixin {
  bool expanded = false;
  final double itemSpacing = 60;
  final EdgeInsets buttonMargins = EdgeInsets.only(bottom: 15, right: 15);
  final double backgroundOpacity = 0.7;
  final Color backgroundColor = Colors.white;

  AnimationController _controller;
  Animation<double> _animation;
  final Duration animationDuration = Duration(milliseconds: 250);

  @override
  void initState() {
    _controller = AnimationController(duration: animationDuration, vsync: this);
    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn))
          ..addListener(
              // Force the StatefulWidget to update as the animation plays
              () => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildIcons(Icons.keyboard_arrow_up);
  }

  Widget buildIcons(IconData toggleIcon) {
    List<Widget> buttons = List<Widget>.from(widget.expandedChildren)
        .reversed // Reverse because positioning goes bottom - up
        .toList()
        .asMap() // Use a map so we can use index in mapping function
        .map((i, w) => MapEntry<int, Widget>(
            i,
            Positioned(
              child: addOpacityAnimation(w),
              bottom: (i + 1) * itemSpacing * _animation.value +
                  buttonMargins.bottom,
              right: buttonMargins.right,
            )))
        .values
        .toList();

    // Background needs to be first so it's under all the buttons
    buttons.insert(0, buildBackground());

    // Child is behind background
    buttons.insert(0, widget.child);

    // We want to add it last so it is on top of all other widgets
    buttons.add(Positioned(
        child: buildToggleButton(toggleIcon),
        bottom: buttonMargins.bottom,
        right: buttonMargins.right));

    return Stack(
      fit: StackFit.expand,
      children: buttons,
    );
  }

  Widget buildToggleButton(IconData icon) {
    return RotationTransition(
        turns: Tween<double>(begin: 0, end: 0.5).animate(_controller),
        child: CircleRaisedButton(onPressed: toggleExpand, child: Icon(icon)));
  }

  Widget addSizeAnimation(Widget base) {
    return SizeTransition(child: base, sizeFactor: _animation);
  }

  Widget addOpacityAnimation(Widget base) {
    return Opacity(opacity: _animation.value, child: base);
  }

  Widget buildBackground() {
    Widget background = GestureDetector(
        onTap: toggleExpand,
        child: Container(
          color:
              backgroundColor.withOpacity(backgroundOpacity * _animation.value),
        ));
    if (!expanded) {
      background =
          IgnorePointer(child: background); // Ignore touches when minimized
    }
    return background;
  }

  void toggleExpand() {
    setState(() {
      this.expanded = !this.expanded;
    });
    this.expanded == true ? _controller.forward() : _controller.reverse();
  }
}
