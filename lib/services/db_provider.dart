import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBProvider {
  Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    Directory appBaseDirectory = await getApplicationDocumentsDirectory();
    String dbFilePath = join(appBaseDirectory.path, "PastMe.db");
    return await openDatabase(dbFilePath,
        version: 3,
        onCreate: databaseFirstTimeSetup,
        onUpgrade: databaseUpgrade);
  }

  FutureOr<void> databaseFirstTimeSetup(Database db, int version) async {
    String noteSetup = '''
CREATE TABLE Note
(
    id INTEGER PRIMARY KEY,
    title TEXT,
    body TEXT
)
    ''';

    String actionItemSetup = '''
CREATE TABLE ActionItem
(
    id INTEGER PRIMARY KEY,
    description TEXT,
    done BOOLEAN,
    dueDate DATETIME,
    parent INTEGER REFERENCES Note(id) ON DELETE CASCADE 
)
    ''';

    await db.execute(noteSetup);
    await db.execute(actionItemSetup);
  }

  FutureOr<void> databaseUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute("DROP TABLE Note;"); // Just drop them for now
    await db.execute("DROP TABLE ActionItem;"); // Just drop them for now
    String setupScript =
        await rootBundle.loadString("assets/sql/setup.sql");

    await db.execute(setupScript);
  }
}
