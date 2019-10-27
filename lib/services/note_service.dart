import 'package:past_me/models/action_item.dart';
import 'package:past_me/models/note.dart';
import 'package:past_me/services/action_item_service.dart';
import 'package:past_me/services/base_service.dart';
import 'package:sqflite/sqflite.dart';

import '../locator.dart';
import 'db_provider.dart';

class NoteService extends BaseService {
  DBProvider dbProvider = locator<DBProvider>();
  ActionItemService actionItemService = locator<ActionItemService>();
  
  List<Note> notes = List<Note>();

  void loadNotes() async {
    setState(ViewState.Busy);
    Database db = await dbProvider.db;
    var dbNoteData = await db.query("Note");
    notes = dbNoteData.map((l) => Note.fromMap(l)).toList();
    await Future.forEach(notes, (note) async {
      note.actionItems = await actionItemService.getActionItems(note);
    });
    setState(ViewState.Idle);
  }

  addNote(Note note) async {
    setState(ViewState.Busy);
    Database db = await dbProvider.db;
    Note existingNote =
        notes.firstWhere((n) => n.id == note.id, orElse: () => null);
    if (existingNote != null) {
      await db.update("Note", note.toMap(), where: 'id = ?', whereArgs: [note.id]);
    } else {
      int id = await db.insert("Note", note.toMap());
      note.id = id;
    }
    await storeActionItems(note);
    setState(ViewState.Idle);
    loadNotes();
  }

  void storeActionItems(Note note) async {
    setState(ViewState.Busy);
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
    setState(ViewState.Idle);
  }

  removeNote(note) async {
    setState(ViewState.Busy);
    Database db = await dbProvider.db;
    await db.delete("Note", where: 'id = ?', whereArgs: [note.id]);
    setState(ViewState.Idle);
    loadNotes();
  }
}
