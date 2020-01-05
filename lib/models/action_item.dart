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

    factory NoteActionItem.from(NoteActionItem other) {
      return NoteActionItem(
        id: other.id,
        parent: other.parent,
        done: other.done,
        description: other.description
      );
    }

    factory NoteActionItem.fromJson(String str) => NoteActionItem.fromMap(json.decode(str));

    bool operator == (other) {
      return this.id == other.id &&
        this.parent == other.parent &&
        this.done == other.done &&
        this.description == other.description;
    }

    String toString() {
      return toJson();
    }

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