import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:past_me/models/note.dart';
import 'package:past_me/services/interfaces/action_item_repository.dart';
import 'package:past_me/services/note_sql_repository.dart';
import 'package:sqflite/sqflite.dart';

class MockDatabase extends Mock implements Database {}

class MockActionItemRepository extends Mock implements ActionItemRepository {}

main() {
  group('Given NoteSqlRepostitory', () {
    Database fakeDb = MockDatabase();
    ActionItemRepository fakeAIRepo = MockActionItemRepository();
    GetIt.instance.registerSingleton<Future<Database>>(Future.value(fakeDb));
    GetIt.instance.registerSingleton<ActionItemRepository>(fakeAIRepo);
    NoteSqlRepository repo = NoteSqlRepository();

    setUp(() {
      reset(fakeDb);
      reset(fakeAIRepo);
    });

    test('When getNotes called Then returns notes in Database', () async {
      var note = Note(actionItems: [], body: 'Test', id: 1);
      when(fakeDb.query('Note'))
          .thenAnswer((_) => Future.value([note.toMap()]));
      var notes = await repo.getNotes();
      expect(listEquals(notes, [note]), true);
    });

    test('When addNote called Then inserts note into database', () async {
      var note = Note(actionItems: [], body: 'Test', id: 1);
      when(fakeDb.insert('Note', any)).thenAnswer((_) => Future.value(1));
      when(fakeAIRepo.getActionItems(any)).thenAnswer((_) => Future.value([]));
      await repo.addNote(note);
      verify(fakeDb.insert('Note', note.toMap())).called(1);
    });

    group('Given note is in database', () {
      var note = Note(actionItems: [], body: 'Test', id: 1);
      setUp(() {
        when(fakeDb.query('Note', where: anyNamed('where'), whereArgs: anyNamed('whereArgs'), limit: anyNamed('limit')))
            .thenAnswer((_) => Future.value([note.toMap()]));
        when(fakeAIRepo.getActionItems(any)).thenAnswer((_) => Future.value([]));
      });
      test('when deleteNote called Then deletes note from database', () async {
        await repo.deleteNote(note.id);
        verify(fakeDb.delete('Note',
            where: anyNamed('where'), whereArgs: [note.id])).called(1);
      });

      test('when getNote called Then returns note', () async {
        var returnedNote = await repo.getNote(note.id);
        expect(returnedNote, note);
      });

      test('When updateNote called Then updates database', () async {
        var updatedNote = Note.from(note);
        updatedNote.body = "Updated";
        await repo.updateNote(updatedNote);
        verify(fakeDb.update(
            'Note', 
            updatedNote.toMap(),
            where: anyNamed('where'), 
            whereArgs: [updatedNote.id]))
            .called(1);
      });
    });

    group('Given note is not in database', () {
      setUp(() {
        when(fakeDb.query('Note',
                where: anyNamed('where'),
                whereArgs: anyNamed('whereArgs'),
                limit: anyNamed('limit')))
            .thenAnswer((_) => Future.value([]));
      });
      
      test('When getNote is called Then returns null', () async {
        expect(await repo.getNote(1), null);
      });

      test('when deleteNote called Then throws ArgumentError', () async {
        expect(repo.deleteNote(1), throwsArgumentError);
      });

      test('when updateNote called Then throws ArgumentError', () async {
        expect(repo.updateNote(Note(id: 1)), throwsArgumentError);
      });
    });
  });
}
