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
        priority: Priority.low,
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
        priority: Priority.medium,
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
          priority: Priority.low,
          taskLength: TaskLength.small,
          eisenhowerCategory: EisenhowerCategory.notUrgentNotImportant,
        );
      }

      expect(noteService.getAllNotes().length, 10000);
    });
  });
}