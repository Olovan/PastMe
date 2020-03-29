import 'package:past_me/models/action_item.dart';
import 'package:past_me/models/note.dart';
import 'package:past_me/services/interfaces/action_item_repository.dart';
import 'package:past_me/services/interfaces/note_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../locator.dart';

class NoteSqlRepository implements NoteRepository {
  Future<Database> dbFuture = locator<Future<Database>>();
  ActionItemRepository actionItemRepo = locator<ActionItemRepository>();
  
  @override
  Future<Note> addNote(Note note) async {
    Database db = await dbFuture;
    int id = await db.insert("Note", note.toMap());
    note.id = id;
    await _storeActionItems(note);
    return note;
  }

  @override
  Future<Note> deleteNote(int id) async {
    Database db = await dbFuture;
    var result = await db.query("Note", where: 'id = ?', whereArgs: [id], limit: 1);
    if(await getNote(id) != null) {
      await db.delete("ActionItem", where: "parent = ?", whereArgs: [id]);
      await db.delete("Note", where: 'id = ?', whereArgs: [id]);
    } else {
      throw new ArgumentError("The id: $id was not found in the database");
    }

    return Note.fromMap(result[0]);
  }

  @override
  Future<Note> getNote(int id) async {
    Database db = await dbFuture;
    var result = await db.query("Note", where: "id = ?", whereArgs: [id], limit: 1);
    if(result != null && result.length == 1) {
      return Note.fromMap(result[0]);
    } else {
      return null;
    }
  }

  @override
  Future<List<Note>> getNotes() async {
    Database db = await dbFuture;
    var results = await db.query("Note");
    var notes = results.map((r) => Note.fromMap(r)).toList();
    await Future.forEach(notes, (note) async {
      note.actionItems = await actionItemRepo.getActionItems(note);
    });
    return notes;
  }

  @override
  Future<Note> updateNote(Note note) async {
    Database db = await dbFuture;
    if(await getNote(note.id) != null) {
      db.update("Note", note.toMap(), where: 'id = ?', whereArgs: [note.id]);
      await _storeActionItems(note);
      return note;
    } else {
      throw new ArgumentError("The id: ${note.id} was not found in the database");
    }
  }

  Future _storeActionItems(Note note) async {
    List<NoteActionItem> existingItems = await actionItemRepo.getActionItems(note);
    List<NoteActionItem> deletedItems = existingItems
      .where((item) => note.actionItems.indexWhere((e) => e.id == item.id) == -1)
      .toList();
    deletedItems.forEach((deletedItem) {
      actionItemRepo.deleteActionItem(deletedItem);
    });
    note.actionItems.forEach((actionItem) {
      actionItem.parent = note.id;
      actionItemRepo.addActionItem(actionItem);
    });
  }
}
