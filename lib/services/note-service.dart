import 'package:past_me/models/note.dart';
import 'package:past_me/services/base_service.dart';
import 'package:sqflite/sqflite.dart';

import '../locator.dart';
import 'db_provider.dart';


class NoteService extends BaseService {
  DBProvider dbProvider = locator<DBProvider>();
  List<Note> notes = List<Note>();

  void loadNotes() async {
    setState(ViewState.Busy);
    Database db = await dbProvider.db;
    var dbNoteData = await db.query("Note");
    notes = dbNoteData.map((l) => Note.fromMap(l)).toList();
    setState(ViewState.Idle);
  }

  addNote(note) async {
    setState(ViewState.Busy);

    Database db = await dbProvider.db;
    Note existingNote =
        notes.firstWhere((n) => n.id == note.id, orElse: () => null);

    if (existingNote != null) {
      await db
          .update("Note", note.toMap(), where: 'id = ?', whereArgs: [note.id]);
    } else {
      await db.insert("Note", note.toMap());
    }
    setState(ViewState.Idle);
    loadNotes();
  }

  removeNote(note) async {
    setState(ViewState.Busy);
    Database db = await dbProvider.db;
    await db.delete("Note", where: 'id = ?', whereArgs: [note.id]);
    setState(ViewState.Idle);
    loadNotes();
  }
}
