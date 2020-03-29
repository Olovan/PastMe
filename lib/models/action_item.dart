import 'dart:convert';

class NoteActionItem {
    int id;
    int parent;
    bool done;
    String description;
    DateTime dueDate;

    NoteActionItem({
        this.id,
        this.parent,
        this.done,
        this.description,
        this.dueDate,
    });

    factory NoteActionItem.from(NoteActionItem other) {
      return NoteActionItem(
        id: other.id,
        parent: other.parent,
        done: other.done,
        description: other.description,
        dueDate: other.dueDate
      );
    }

    factory NoteActionItem.fromJson(String str) => NoteActionItem.fromMap(json.decode(str));

    bool operator == (other) {
      return other is NoteActionItem &&
        this.id == other.id &&
        this.parent == other.parent &&
        this.done == other.done &&
        this.description == other.description && 
        this.dueDate?.millisecondsSinceEpoch == other.dueDate?.millisecondsSinceEpoch;
    }

    int get hashCode => this.id.hashCode ^ this.parent.hashCode ^ this.done.hashCode ^ this.description.hashCode ^ this.dueDate.hashCode;

    String toString() {
      return toJson();
    }

    String toJson() => json.encode(toMap());

    factory NoteActionItem.fromMap(Map<String, dynamic> json) => NoteActionItem(
        id: json["id"],
        parent: json["parent"],
        done: json["done"] == 1,
        description: json["description"],
        dueDate: json["dueDate"] != null ? DateTime.fromMillisecondsSinceEpoch(json["dueDate"], isUtc: true) : null,
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "parent": parent,
        "done": done,
        "description": description,
        "dueDate": dueDate?.toUtc()?.millisecondsSinceEpoch,
    };
}