import 'package:flutter_test/flutter_test.dart';
import 'package:notes/viewmodels/note_list_viewmodel.dart';

void main() {
  group('NoteListViewModel', () {
    late NoteListViewModel viewModel;

    setUp(() {
      viewModel = NoteListViewModel();
    });

    test('addNote() sollte mit Sonderzeichen umgehen', () {
      viewModel.addNote(
        '@Test#Note€',
        'Beschreibung mit Sonderzeichen: @, #, €',
      );
      final note = viewModel.notes.last;
      expect(note.title, '@Test#Note€');
      expect(note.description, 'Beschreibung mit Sonderzeichen: @, #, €');
    });

    test('deleteNote() sollte keine Fehler werfen, wenn die Notiz nicht existiert', () {
      expect(() => viewModel.deleteNote('nonexistent-id'), returnsNormally);
    });

    test('updateNote() sollte keine Fehler werfen, wenn die Notiz nicht existiert', () {
      expect(() => viewModel.updateNote('nonexistent-id', 'title', 'Updated Title'), returnsNormally);
    });

    test('updateNote() sollte mit sehr langen Strings umgehen', () {
      viewModel.addNote(
        'Test Note',
        'Beschreibung',
      );

      final note = viewModel.notes.last;
      final longString = 'a' * 10000; // 10.000 Zeichen
      viewModel.updateNote(note.id, 'title', longString);

      expect(viewModel.notes.first.title.length, 10000);
    });

    test('Nebenläufigkeit: Mehrere Threads sollten korrekt funktionieren', () async {
      final futures = List.generate(1000, (index) {
        return Future(() {
          viewModel.addNote(
            'Note $index',
            'Beschreibung $index',
          );
        });
      });

      await Future.wait(futures);

      expect(viewModel.notes.length, 1000);
    });
  });
}