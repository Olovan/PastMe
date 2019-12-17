import 'package:past_me/models/action_item.dart';
import 'package:past_me/models/note.dart';
import 'package:past_me/services/action_item_repository.dart';
import 'package:past_me/services/db_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../locator.dart';

class ActionItemSqlRepository implements ActionItemRepository {
  DBProvider dbProvider = locator<DBProvider>();

  @override
  Future<bool> addActionItem(NoteActionItem actionItem) async {
    Database db = await dbProvider.db;
    if (actionItem.id != null) {
      await db.update("ActionItem", actionItem.toMap(),
          where: 'id = ?', whereArgs: [actionItem.id]);
    } else {
      int id = await db.insert("ActionItem", actionItem.toMap());
      actionItem.id = id;
    }
    return true;
  }

  @override
  Future<List<NoteActionItem>> getActionItems(Note parent) async {
    Database db = await dbProvider.db;
    var dbResults = await db
        .query("ActionItem", where: 'parent = ?', whereArgs: [parent.id]);
    var actionItems = dbResults.map((r) => NoteActionItem.fromMap(r)).toList();
    return actionItems;
  }

  @override
  Future<bool> deleteActionItem(NoteActionItem actionItem) async {
    Database db = await dbProvider.db;
    await db.delete("ActionItem", where: 'id = ?', whereArgs: [actionItem.id]);
    return true;
  }

  @override
  Future<bool> editActionItem(NoteActionItem actionItem) async {
    Database db = await dbProvider.db;
    await db.update('ActionItem', actionItem.toMap(),
        where: 'id = ?', whereArgs: [actionItem.id]);
    return true;
  }

  @override
  Future<NoteActionItem> findActionItem(int id) async {
    Database db = await dbProvider.db;
    List<Map> results = await db.query("ActionItem", where: 'id = ?', whereArgs: [id]);
    if(results.length != 0)
      return NoteActionItem.fromMap(results[0]);
    else
      return null;
  }
}
