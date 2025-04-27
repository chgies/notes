import '../models/note.dart';
import '../services/note_service.dart';

class NoteListViewModel {
  final NoteService _noteService = NoteService();

  List<Note> get notes => _noteService.getAllNotes();

  void addNote(String title, String description) {
    _noteService.createNote(
      title: title,
      description: description,
      taskLength: TaskLength.small,
      eisenhowerCategory: EisenhowerCategory.notUrgentNotImportant,
      dueDate: DateTime.now().add(Duration(days: 7)),
      tags: ["Neu"],
    );
  }

  void updateNote(String id, String whatToUpdate, String newValue) {
    _noteService.updateNote(
      id: id,
      title: whatToUpdate == "title" ? newValue : null,
      description: whatToUpdate == "description" ? newValue : null,
      taskLength: whatToUpdate == "taskLength" ? TaskLength.values.firstWhere((e) => e.name == newValue) : null,
      eisenhowerCategory: whatToUpdate == "eisenhowerCategory" ? EisenhowerCategory.values.firstWhere((e) => e.name == newValue) : null,
      dueDate: whatToUpdate == "dueDate" ? DateTime.parse(newValue) : null,
      tags: whatToUpdate == "tags" ? newValue.split(",") : null,
    );
  }

  void deleteNote(String id) {
    _noteService.deleteNote(id);
  }

  Note getLastNote() {
    return _noteService.getAllNotes().last;
  }


  getAttribute(String id, String attribute) {
    return _noteService.getAttribute(id, attribute);
  }
}