import 'dart:async';

import 'package:past_me/locator.dart';
import 'package:past_me/Events/note_event.dart';
import 'package:past_me/models/note.dart';
import 'package:past_me/services/note_repository.dart';

class NoteService {
  Sink<List<Note>> get _noteSink => _controller.sink;

  NoteRepository _repo = locator<NoteRepository>();
  var _controller = new StreamController<List<Note>>();
  List<Note> notes = [];
  Stream<List<Note>> get stream => _controller.stream;

  processEvent(NoteEvent event) async {
    logNoteEvent(event);
        if (event is NoteCreatedEvent) {
          createNote(event.note);
        } else if (event is NoteDeletedEvent) {
          deleteNote(event.note);
        } else if (event is NoteUpdatedEvent) {
          updateNote(event.note);
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
    
      void logNoteEvent(NoteEvent event) {
        print(event.runtimeType.toString() + " : " + event?.note.toString() ?? "NULL");
      }
}
