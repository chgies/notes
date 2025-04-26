import 'package:uuid/uuid.dart'; // Für die Generierung einer eindeutigen ID
import 'package:collection/collection.dart'; // Für die Verwendung von firstWhereOrNull
import '../models/note.dart';

class NoteService {
  final List<Note> _notes = [];

  // Neue Notiz erstellen
  Note createNote({
    required String title,
    required String description,
    required Priority priority,
    required TaskLength taskLength,
    required EisenhowerCategory eisenhowerCategory,
    DateTime? dueDate,
    List<String> tags = const [],
  }) {
    final newNote = Note(
      id: const Uuid().v4(), // Generiert eine eindeutige ID
      title: title,
      description: description,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      priority: priority,
      taskLength: taskLength,
      eisenhowerCategory: eisenhowerCategory,
      tags: tags,
    );
    _notes.add(newNote);
    return newNote;
  }

    // Notiz löschen
  bool deleteNote(String id) {
    final initialLength = _notes.length; // Länge der Liste vor dem Entfernen
    _notes.removeWhere((note) => note.id == id); // Entfernt Notizen mit der passenden ID
    return _notes.length < initialLength; // Prüft, ob die Länge der Liste sich geändert hat
  }

    // Notiz finden
  Note? findNoteById(String id) {
    return _notes.firstWhereOrNull((note) => note.id == id);
  }

    // Notiz aktualisieren
  bool updateNote({
    required String id,
    String? title,
    String? description,
    Priority? priority,
    TaskLength? taskLength,
    EisenhowerCategory? eisenhowerCategory,
    DateTime? dueDate,
    List<String>? tags,
    bool? completed,
  }) {
    final note = findNoteById(id);
    if (note == null) return false;

    // Erstellen einer neuen Instanz mit aktualisierten Werten
    final updatedNote = Note(
      id: note.id,
      title: title ?? note.title,
      description: description ?? note.description,
      createdAt: note.createdAt,
      dueDate: dueDate ?? note.dueDate,
      priority: priority ?? note.priority,
      taskLength: taskLength ?? note.taskLength,
      eisenhowerCategory: eisenhowerCategory ?? note.eisenhowerCategory,
      tags: tags ?? note.tags,
      completed: completed ?? note.completed,
    );

    // Alte Notiz ersetzen
    final index = _notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notes[index] = updatedNote;
      return true;
    }
    return false;
  }

  // Alle Notizen abrufen
  List<Note> getAllNotes() {
    return _notes;
  }
}