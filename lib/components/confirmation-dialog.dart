
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConfirmationDialog {
  static Future<bool> show(BuildContext context, { String title = "Are you sure?", String body = "" }) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text("Confirm"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }
}