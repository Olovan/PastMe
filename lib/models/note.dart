import 'dart:convert';

import 'package:past_me/models/action_item.dart';

class Note {
  int id;
  String body = "";
  List<NoteActionItem> actionItems = [];

  Note({id, body, actionItems}) {
    this.id = id;
    this.body = body ?? "";
    this.actionItems = actionItems ?? [];
  }

  factory Note.fromRawJson(String str) => Note.fromMap(json.decode(str));

  @override
  String toString() {
    return "{ id: $id, body: $body, actionItems: [${_getActionItemsString()}] }";
  }

  static Note from(Note other) {
    List<NoteActionItem> items = other.actionItems
      .map((i) => NoteActionItem.from(i))
      .toList();
    Note newNote = Note.fromMap(other.toMap());
    newNote.actionItems = items;
    return newNote;
  }

  String _getActionItemsString() {
    return actionItems.map((i) => "'${i.description}'").join(", ");
  }

  String toJson() => json.encode(toMap());

  factory Note.fromMap(Map<String, dynamic> map) => Note(
        id: map["id"],
        body: map["body"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "body": body,
      };
}

class ActionItem {}
