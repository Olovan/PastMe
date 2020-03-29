import 'package:past_me/models/action_item.dart';
import 'package:past_me/models/note.dart';

class ActionItemRepository {
  Future<bool> addActionItem(NoteActionItem actionItem) async { return false; } //Stub
  Future<bool> editActionItem(NoteActionItem actionItem) async { return false; } //Stub
  Future<List<NoteActionItem>> getActionItems(Note parent) async { return null; } //Stub
  Future<bool> deleteActionItem(NoteActionItem actionItem) async { return false; } //Stub
  Future<NoteActionItem> findActionItem(int id) async { return null; } //Stub
}