import 'dart:convert';

class ActionItem {
    int id;
    int parent;
    bool done;
    String description;

    ActionItem({
        this.id,
        this.parent,
        this.done,
        this.description,
    });

    factory ActionItem.fromJson(String str) => ActionItem.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ActionItem.fromMap(Map<String, dynamic> json) => ActionItem(
        id: json["id"],
        parent: json["parent"],
        done: json["done"],
        description: json["description"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "parent": parent,
        "done": done,
        "description": description,
    };
}