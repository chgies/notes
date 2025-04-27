import 'package:flutter_test/flutter_test.dart';
import 'package:notes/models/note.dart';
import 'package:notes/services/note_service.dart';

void main() {
  group('NoteService', () {
    late NoteService noteService;

    setUp(() {
      noteService = NoteService();
    });

    test('createNote() sollte mit leeren Strings umgehen', () {
      final note = noteService.createNote(
        title: '',
        description: '',
        taskLength: TaskLength.small,
        eisenhowerCategory: EisenhowerCategory.notUrgentNotImportant,
      );

      expect(note.title, '');
      expect(note.description, '');
    });

    test('createNote() sollte mit sehr langen Strings umgehen', () {
      final longString = 'a' * 10000; // 10.000 Zeichen
      final note = noteService.createNote(
        title: longString,
        description: longString,
        taskLength: TaskLength.large,
        eisenhowerCategory: EisenhowerCategory.urgentImportant,
      );

      expect(note.title.length, 10000);
      expect(note.description.length, 10000);
    });

    test('deleteNote() sollte keine Fehler werfen, wenn die Notiz nicht existiert', () {
      final success = noteService.deleteNote('nonexistent-id');
      expect(success, false);
    });

    test('getAllNotes() sollte mit vielen Notizen umgehen', () {
      for (int i = 0; i < 10000; i++) {
        noteService.createNote(
          title: 'Note $i',
          description: 'Beschreibung $i',
          taskLength: TaskLength.small,
          eisenhowerCategory: EisenhowerCategory.notUrgentNotImportant,
        );
      }

      expect(noteService.getAllNotes().length, 10000);
    });
  });

 group('NoteService - getAttribute()', () {
    late NoteService noteService;
    late Note testNote;

    setUp(() {
      noteService = NoteService();
      testNote = noteService.createNote(
        title: 'Test Note',
        description: 'Test Beschreibung',
        taskLength: TaskLength.large,
        eisenhowerCategory: EisenhowerCategory.urgentImportant,
        dueDate: DateTime(2025, 4, 30),
        tags: ['Tag1', 'Tag2'],
      );
    });

    test('getAttribute() sollte den Titel zurückgeben', () {
      final result = noteService.getAttribute(testNote.id, 'title');
      expect(result, 'Test Note');
    });

    test('getAttribute() sollte die Beschreibung zurückgeben', () {
      final result = noteService.getAttribute(testNote.id, 'description');
      expect(result, 'Test Beschreibung');
    });

    test('getAttribute() sollte die Aufgabenlänge zurückgeben', () {
      final result = noteService.getAttribute(testNote.id, 'taskLength');
      expect(result, 'large');
    });

    test('getAttribute() sollte die Eisenhower-Kategorie zurückgeben', () {
      final result = noteService.getAttribute(testNote.id, 'eisenhowerCategory');
      expect(result, 'urgentImportant');
    });

    test('getAttribute() sollte das Erstellungsdatum zurückgeben', () {
      final result = noteService.getAttribute(testNote.id, 'createdAt');
      expect(result, isA<DateTime>());
    });

    test('getAttribute() sollte das Fälligkeitsdatum zurückgeben', () {
      final result = noteService.getAttribute(testNote.id, 'dueDate');
      expect(result, DateTime(2025, 4, 30));
    });

    test('getAttribute() sollte die Tags zurückgeben', () {
      final result = noteService.getAttribute(testNote.id, 'tags');
      expect(result, ['Tag1', 'Tag2']);
    });

    test('getAttribute() sollte den Status "completed" zurückgeben', () {
      final result = noteService.getAttribute(testNote.id, 'isCompleted');
      expect(result, false);
    });

    test('getAttribute() sollte eine Exception werfen, wenn das Attribut nicht existiert', () {
      expect(() => noteService.getAttribute(testNote.id, 'nonexistentAttribute'), throwsException);
    });

    test('getAttribute() sollte einen leeren String zurückgeben, wenn die Notiz nicht existiert', () {
      final result = noteService.getAttribute('nonexistent-id', 'title');
      expect(result, '');
    });
  });
}