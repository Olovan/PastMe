
import 'package:get_it/get_it.dart';
import 'package:past_me/services/action_item_service.dart';
import 'package:past_me/services/note_service.dart';

import 'services/db_provider.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => DBProvider());
  locator.registerLazySingleton(() => NoteService());
  locator.registerLazySingleton(() => ActionItemService());
}