import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:past_me/models/action_item.dart';
import 'package:past_me/models/note.dart';
import 'package:past_me/services/action_item_sql_repository.dart';
import 'package:sqflite/sqflite.dart';

class FakeDatabase extends Mock implements Database {}

main() {
  group("GIVEN ActionItemSqlRepository", () {
    var fakeDb = FakeDatabase();
    GetIt.instance.registerSingleton<Future<Database>>(Future.value(fakeDb));
    var repo = ActionItemSqlRepository();

    setUp(() {
      reset(fakeDb);
    });

    test( "WHEN getActionItems called THEN should return all ActionItems of Parent Note", () async {
      var parent = Note(id: 1);
      var actionItem = NoteActionItem(description: "TEST", done: false, id: 1, parent: 1);
      when(fakeDb.query('ActionItem',
              where: anyNamed("where"), whereArgs: anyNamed("whereArgs")))
          .thenAnswer((_) => Future.value([actionItem.toMap()]));
      var result = await repo.getActionItems(parent);
      expect(listEquals([actionItem], result), true);
    });

    group("GIVEN ActionItem already exists in Database", () {
      var actionItem = NoteActionItem(id: 1, description: "TEST", done: false, parent: 1);
      setUp((){
        actionItem = NoteActionItem(id: 1, description: "TEST", done: false, parent: 1);
        when(fakeDb.query("ActionItem", where: anyNamed("where"), whereArgs: anyNamed("whereArgs")))
          .thenAnswer((_) => Future.value([actionItem.toMap()]));
      });
      test("WHEN addActionItem called THEN should update ActionItem in database", () async {
        await repo.addActionItem(actionItem);
        verify(fakeDb.update("ActionItem", actionItem.toMap(), where: anyNamed("where"), whereArgs: anyNamed("whereArgs")))
          .called(1);
      });

      test("WHEN editActionItem called THEN should update ActionItem in database", () async {
        await repo.editActionItem(actionItem);
        verify(fakeDb.update("ActionItem", actionItem.toMap(), where: anyNamed("where"), whereArgs: anyNamed("whereArgs")))
          .called(1);
      });

      test("WHEN deleteActionItem called THEN should delete ActionItem from database", () async {
        await repo.deleteActionItem(actionItem);
        verify(fakeDb.delete("ActionItem", where: anyNamed("where"), whereArgs: anyNamed("whereArgs")))
          .called(1);
      });
    });
    test("WHEN addActionItem called THEN should insert ActionItem to database", () async {
      var actionItem = NoteActionItem(id: null, description: "TEST", done: false, parent: 1);
      await repo.addActionItem(actionItem);
      verify(fakeDb.insert('ActionItem', any)).called(1);
    });
  });
}
