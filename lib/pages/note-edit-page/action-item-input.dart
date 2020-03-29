import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class ActionItemInput extends StatefulWidget {
  final Function(String) onSubmit;

  ActionItemInput(this.onSubmit);

  @override
  _ActionItemInputState createState() => _ActionItemInputState();
}

class _ActionItemInputState extends State<ActionItemInput> {
  @override
  Widget build(BuildContext context) {
    return buildActionItemInput(context);
  }

  TextEditingController _actionItemInputController;
  FocusNode _focusNode;
  String newActionItem;
   

  @override
  initState() {
    _actionItemInputController = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  dispose() {
    _actionItemInputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget buildActionItemInput(context) {
    var theme = Theme.of(context);
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          controller: _actionItemInputController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: "Add action item",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: theme.accentColor)),
            fillColor: theme.backgroundColor,
            filled: true,
            suffixIcon: addNewActionItemButton(context),
          ),
          onChanged: (value) => newActionItem = value,
          onFieldSubmitted: (value) {
            addActionItem();
          },
          textInputAction: TextInputAction.done,
        ));
  }

  Widget addNewActionItemButton(context) {
    var theme = Theme.of(context);
    return GestureDetector(
      child: Icon(
        Icons.add_circle,
        color: theme.accentColor,
      ),
      onTap: addActionItem,
    );
  }

  void addActionItem() {
    if (newActionItem.isNotEmpty) {
      widget.onSubmit(newActionItem);
      // Workaround for error thrown about invalid text selection
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _focusNode.unfocus();
        _actionItemInputController.clear();
        _focusNode.requestFocus();
        setState(() {});
      });
    }
  }
}