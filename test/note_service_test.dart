import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:past_me/models/Events/note_event.dart';
import 'package:past_me/models/note.dart';
import 'package:past_me/services/interfaces/note_repository.dart';
import 'package:past_me/services/note_service.dart';

class FakeNoteRepository extends Mock implements NoteRepository {}

main() {
  group("GIVEN a NoteService", () {
    var fakeRepo = FakeNoteRepository();
    GetIt.instance.registerSingleton<NoteRepository>(fakeRepo);
    var service = NoteService();

    setUp(() {
      reset(fakeRepo);
      service.notes = [];
    });

    test("WHEN it receives a NoteCreatedEvent THEN it should create the note", () async {
      var note = Note(body: "NEW");
      await service.processEvent(NoteCreatedEvent(note));
      verify(fakeRepo.addNote(note)).called(1);
      expect(listEquals([note], service.notes), true);
    });

    test("WHEN it receives a NoteDeletedEvent THEN it should delete the note", () async {
      var note = Note(body: "DELETED");
      service.notes.add(note);
      await service.processEvent(NoteDeletedEvent(note));
      verify(fakeRepo.deleteNote(note.id)).called(1);
      expect(listEquals([], service.notes), true);
    });
    
    test("WHEN it receives a NoteUpdatedEvent THEN it should update the note", () async {
      var note = Note(id: 1, body: "Original");
      service.notes.add(Note.from(note));
      note.body = "UPDATED";
      await service.processEvent(NoteUpdatedEvent(note));
      verify(fakeRepo.updateNote(note)).called(1);
      expect(listEquals([note], service.notes), true);
    });

    test("WHEN it receives a NoteListChanged event THEN it should get the notes", () async {
      var note = Note(body: "New");
      when(fakeRepo.getNotes()).thenAnswer((_) => Future.value([note]));
      await service.processEvent(NoteListChanged());
      verify(fakeRepo.getNotes()).called(1);
      expect(listEquals([note], service.notes), true);
    });
  });
}
