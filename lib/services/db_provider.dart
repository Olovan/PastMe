import 'dart:async';
import 'dart:io';

import 'package:past_me/services/base_service.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBProvider extends BaseService {
  Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    Directory appBaseDirectory = await getApplicationDocumentsDirectory();
    String dbFilePath = join(appBaseDirectory.path, "PastMe.db");
    return await openDatabase(dbFilePath, version: 1, onCreate: databaseFirstTimeSetup);
  }

  FutureOr<void> databaseFirstTimeSetup(Database db, int version) async {
    String setupScript = 
      "CREATE TABLE Note (" +
      "id INTEGER PRIMARY KEY," +
      "title TEXT," +
      "body TEXT" +
      ")";

    await db.execute(setupScript);
  }
}
