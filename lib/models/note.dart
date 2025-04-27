import 'package:uuid/uuid.dart';

enum TaskLength { small, medium, large }
enum EisenhowerCategory { urgentImportant, urgentNotImportant, notUrgentImportant, notUrgentNotImportant }

class Note {
  final String id; // Eindeutige ID für die Notiz
  final String title; // Titel der Notiz
  final String description; // Beschreibung der Aufgabe
  final DateTime createdAt; // Erstellungsdatum
  final DateTime? dueDate; // Fälligkeitsdatum (optional)
  final TaskLength taskLength; // Länge der Aufgabe (S, M, L)
  final EisenhowerCategory eisenhowerCategory; // Eisenhower-Matrix-Kategorie
  final List<String> tags; // Tags für zusätzliche Kategorisierung
  final bool completed; // Status der Aufgabe

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.dueDate,
    required this.taskLength,
    required this.eisenhowerCategory,
    this.tags = const [],
    this.completed = false,
  });

  // Methode zur Konvertierung in ein allgemeines JSON-Format (z. B. für APIs)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'taskLength': taskLength.name,
      'eisenhowerCategory': eisenhowerCategory.name,
      'tags': tags,
      'completed': completed,
    };
  }

  // Methode zur Erstellung aus JSON (z. B. für Import aus anderen Programmen)
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] ?? const Uuid().v4(),
      title: json['title'] ?? 'Unbekannter Titel',
      description: json['description'] ?? 'Keine Beschreibung',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      taskLength: TaskLength.values.firstWhere((e) => e.name == json['taskLength'], orElse: () => TaskLength.small),
      eisenhowerCategory: EisenhowerCategory.values.firstWhere((e) => e.name == json['eisenhowerCategory'], orElse: () => EisenhowerCategory.urgentImportant),
      tags: List<String>.from(json['tags'] ?? []),
      completed: json['completed'] ?? false,
    );
  }
}