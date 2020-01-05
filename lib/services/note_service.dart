import 'dart:async';
import 'dart:developer';

import 'package:past_me/locator.dart';
import 'package:past_me/Events/note_event.dart';
import 'package:past_me/models/note.dart';
import 'package:past_me/services/note_repository.dart';

class NoteService {
  NoteRepository _repo = locator<NoteRepository>();
  List<Note> notes = [];
  var _controller = new StreamController<List<Note>>();
  Stream<List<Note>> get stream => _controller.stream;
  Sink<List<Note>> get _noteSink => _controller.sink;

  Future processEvent(NoteEvent event) async {
    if (event is NoteCreatedEvent) {
      await createNote(event.note);
    } else if (event is NoteDeletedEvent) {
      await deleteNote(event.note);
    } else if (event is NoteUpdatedEvent) {
      await updateNote(event.note);
    } else {
      await reloadNotes();
    }
  }

  Future reloadNotes() async {
    notes = await _repo.getNotes();
    _noteSink.add(notes);
  }

  void deleteNote(Note note) async {
    notes.removeWhere((n) => n.id == note.id);
    await _repo.deleteNote(note.id);
    _noteSink.add(notes);
  }

  void createNote(Note note) async {
    notes.add(note);
    await _repo.addNote(note);
    _noteSink.add(notes);
  }

  dispose() {
    _controller.close();
  }

  void updateNote(Note note) async {
    notes.removeWhere((n) => n.id == note.id);
    notes.add(note);
    await _repo.updateNote(note);
    _noteSink.add(notes);
  }

}

class LoggingNoteService extends NoteService {
  @override
  Future processEvent(NoteEvent event) async {
    log(event.runtimeType.toString() + " : " + event?.note.toString() ?? "NULL");
    await super.processEvent(event);
    log("Notes: " + notes.toString());
  }
}
