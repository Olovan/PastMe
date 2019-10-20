
import 'package:get_it/get_it.dart';
import 'package:past_me/services/note-service.dart';

import 'services/db_provider.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => DBProvider());
  locator.registerLazySingleton(() => NoteService());
}