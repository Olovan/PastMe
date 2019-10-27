
import 'package:past_me/models/action_item.dart';
import 'package:past_me/models/note.dart';
import 'package:past_me/services/base_service.dart';
import 'package:past_me/services/db_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../locator.dart';

class ActionItemService extends BaseService {
  DBProvider dbProvider = locator<DBProvider>();

  addActionItem(NoteActionItem actionItem) async {
    setState(ViewState.Busy);
    Database db = await dbProvider.db;
    if(actionItem.id != null) {
      await db.update("ActionItem", actionItem.toMap(), where: 'id = ?', whereArgs: [actionItem.id]);
    } else {
      int id = await db.insert("ActionItem", actionItem.toMap());
      actionItem.id = id;
    }
    setState(ViewState.Idle);
  }

  Future<List<NoteActionItem>> getActionItems(Note parent) async {
    setState(ViewState.Busy);
    Database db = await dbProvider.db;
    var dbResults = await db.query("ActionItem", where: 'parent = ?', whereArgs: [parent.id]);
    var actionItems = dbResults.map((r) => NoteActionItem.fromMap(r)).toList();
    setState(ViewState.Idle);
    return actionItems;
  }

  deleteActionItem(NoteActionItem actionItem) async {
    setState(ViewState.Busy);
    Database db = await dbProvider.db;
    await db.delete("ActionItem", where: 'id = ?', whereArgs: [actionItem.id]);
    setState(ViewState.Idle);
  }
}