import 'dart:convert';

class NoteActionItem {
    int id;
    int parent;
    bool done;
    String description;

    NoteActionItem({
        this.id,
        this.parent,
        this.done,
        this.description,
    });

    factory NoteActionItem.fromJson(String str) => NoteActionItem.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory NoteActionItem.fromMap(Map<String, dynamic> json) => NoteActionItem(
        id: json["id"],
        parent: json["parent"],
        done: json["done"] == 1,
        description: json["description"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "parent": parent,
        "done": done,
        "description": description,
    };
}