import 'dart:convert';

class Note {
    int id;
    String title;
    String body;

    Note({
        this.id,
        this.title,
        this.body,
    });

    factory Note.fromRawJson(String str) => Note.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Note.fromMap(Map<String, dynamic> map) => Note(
        id: map["id"],
        title: map["title"],
        body: map["body"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "body": body,
    };
}

class ActionItem {

}