import 'package:flutter_test/flutter_test.dart';
import 'package:notes/models/note.dart';

void main() {
  group('Note', () {
    test('toJson() sollte mit leeren Feldern umgehen', () {
      final note = Note(
        id: '1',
        title: '',
        description: '',
        createdAt: DateTime.now(),
        taskLength: TaskLength.small,
        eisenhowerCategory: EisenhowerCategory.notUrgentNotImportant,
      );

      final json = note.toJson();

      expect(json['title'], '');
      expect(json['description'], '');
    });

    test('toJson() sollte mit Sonderzeichen umgehen', () {
      final note = Note(
        id: '1',
        title: '@Test#Note€',
        description: 'Beschreibung mit Sonderzeichen: @, #, €',
        createdAt: DateTime.now(),
        taskLength: TaskLength.large,
        eisenhowerCategory: EisenhowerCategory.urgentImportant,
      );

      final json = note.toJson();

      expect(json['title'], '@Test#Note€');
      expect(json['description'], 'Beschreibung mit Sonderzeichen: @, #, €');
    });

    test('fromJson() sollte mit unvollständigen Daten umgehen', () {
      final json = {
        'id': '1',
        'title': 'Test Note',
        // description fehlt
      };

      expect(() => Note.fromJson(json), returnsNormally);
    });
  });
}