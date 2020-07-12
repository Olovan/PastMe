
import 'package:get_it/get_it.dart';
import 'package:past_me/services/action_item_sql_repository.dart';
import 'package:past_me/services/interfaces/action_item_repository.dart';
import 'package:past_me/services/interfaces/note_repository.dart';
import 'package:past_me/services/note_service.dart';
import 'package:past_me/services/note_sql_repository.dart';
import 'package:past_me/services/notifications.dart';
import 'package:sqflite/sqflite.dart';

import 'services/db_provider.dart';

final locator = GetIt.instance;

void setupLocator() {
  //locator.registerLazySingleton(() => DBProvider());
  locator.registerLazySingleton<NoteRepository>(() => NoteSqlRepository());
  locator.registerLazySingleton<ActionItemRepository>(() => ActionItemSqlRepository());
  locator.registerLazySingleton<NoteService>(() => NoteService());
  locator.registerLazySingleton<Future<Database>>(() => DBProvider().db);
  locator.registerLazySingleton<NotificationSystem>(() => NotificationSystem());
}