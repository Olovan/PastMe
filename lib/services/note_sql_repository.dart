import 'package:past_me/models/action_item.dart';
import 'package:past_me/models/note.dart';
import 'package:past_me/services/action_item_repository.dart';
import 'package:past_me/services/note_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../locator.dart';
import 'db_provider.dart';

class NoteSqlRepository implements NoteRepository {
  DBProvider dbProvider = locator<DBProvider>();
  ActionItemRepository actionItemService = locator<ActionItemRepository>();
  
  @override
  Future<Note> addNote(Note note) async {
    Database db = await dbProvider.db;
    int id = await db.insert("Note", note.toMap());
    note.id = id;
    await storeActionItems(note);
    return note;
  }

  @override
  Future<Note> deleteNote(int id) async {
    Database db = await dbProvider.db;
    var result = await db.query("Note", where: 'id = ?', whereArgs: [id], limit: 1);
    if(getNote(id) != null) {
      await db.delete("Note", where: 'id = ?', whereArgs: [id]);
      return Note.fromMap(result[0]);
    } else {
      throw new ArgumentError("The id: $id was not found in the database");
    }

  }

  @override
  Future<Note> getNote(int id) async {
    Database db = await dbProvider.db;
    var result = await db.query("Note", where: "id = ?", whereArgs: [id], limit: 1);
    if(result != null && result.length == 1) {
      return Note.fromMap(result[0]);
    } else {
      return null;
    }
  }

  @override
  Future<List<Note>> getNotes() async {
    Database db = await dbProvider.db;
    var results = await db.query("Note");
    var notes = results.map((r) => Note.fromMap(r)).toList();
    await Future.forEach(notes, (note) async {
      note.actionItems = await actionItemService.getActionItems(note);
    });
    return notes;
  }

  @override
  Future<Note> updateNote(Note note) async {
    Database db = await dbProvider.db;
    if(getNote(note.id) != null) {
      db.update("Note", note.toMap(), where: 'id = ?', whereArgs: [note.id]);
      await storeActionItems(note);
      return note;
    } else {
      throw new ArgumentError("The id: ${note.id} was not found in the database");
    }
  }

  Future storeActionItems(Note note) async {
    List<NoteActionItem> existingItems = await actionItemService.getActionItems(note);
    List<NoteActionItem> deletedItems = existingItems
      .where((item) => note.actionItems.indexWhere((e) => e.id == item.id) == -1)
      .toList();
    deletedItems.forEach((deletedItem) {
      actionItemService.deleteActionItem(deletedItem);
    });
    note.actionItems.forEach((actionItem) {
      actionItem.parent = note.id;
      actionItemService.addActionItem(actionItem);
    });
  }
}
