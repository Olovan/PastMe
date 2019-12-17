import 'package:past_me/models/note.dart';

class NoteEvent {
  Note note;
  NoteEvent();
  NoteEvent._specific(this.note);
}

class NoteCreatedEvent extends NoteEvent {
  NoteCreatedEvent(Note note) : super._specific(note);
}

class NoteDeletedEvent extends NoteEvent {
  NoteDeletedEvent(Note note) : super._specific(note);
}

class NoteUpdatedEvent extends NoteEvent {
  NoteUpdatedEvent(Note note) : super._specific(note);
}

class NoteListChanged extends NoteEvent {
}