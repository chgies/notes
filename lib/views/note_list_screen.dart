//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../viewmodels/note_list_viewmodel.dart';
import '../models/note.dart';

  // Vordefinierte Werte
final List<String> taskLengthOptions = NoteListViewModel.getTaskLengths();
final List<String> eisenhowerOptions = NoteListViewModel.getEisenhowerCategories();


class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  NoteListScreenState createState() => NoteListScreenState();
}

class NoteListScreenState extends State<NoteListScreen> {
  final NoteListViewModel viewModel = NoteListViewModel();
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _addNewNote() {
    setState(() {
      viewModel.addNote("Neue Notiz", "Beschreibung der neuen Notiz");
      final newNote = viewModel.getLastNote(); // Holt die zuletzt hinzugefügte Notiz
      _editingController.text = newNote.title; // Setzt den Titel einer neuen Notiz in das Textfeld
      _focusNode.requestFocus(); // Setzt den Fokus auf das Eingabefeld
      _editingController.selection = TextSelection.fromPosition(TextPosition(offset: _editingController.text.length)); // Setzt den Cursor ans Ende des Textes
    });
  }

  void _showOptions(Note note) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Bearbeiten"),
              onTap: () {
                Navigator.pop(context);
                // Bearbeitungslogik hier einfügen
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Löschen"),
              onTap: () {
                setState(() {
                  viewModel.deleteNote(note.id);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notes = viewModel.notes;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Schließt die Tastatur, wenn der Benutzer außerhalb des Textfeldes tippt
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notizen"),
        ),
        body: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return ExpansionTile(
              dense: true,
                title: index == notes.length - 1 
                ? ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 48),
                  child: IntrinsicWidth(
                    child: NoteTextField(
                      attribute: "title",
                      note: note,
                      viewModel: viewModel,
                    ),
                  ),
                )
                : Text(note.title),
              subtitle: Text(note.description),
            trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showOptions(note),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column( 
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NoteTextField(
                        attribute: "title",
                        note: note,
                        viewModel: viewModel,
                      ),
                      NoteTextField(
                        attribute: "description",
                        note: note,
                        viewModel: viewModel,
                      ),
                      NoteTextField(
                        attribute: "taskLength",
                        note: note,
                        viewModel: viewModel,
                      ),
                      NoteTextField(
                        attribute: "eisenhowerCategory",
                        note: note,
                        viewModel: viewModel,
                      ),
                      NoteTextField(
                        attribute: "createdAt", 
                        note: note, 
                        viewModel: viewModel
                        ),
                      NoteTextField(
                        attribute: "dueDate",
                        note: note,
                        viewModel: viewModel,
                      ),
                      NoteTextField(
                        attribute: "tags",
                        note: note,
                        viewModel: viewModel,
                      ),
                      NoteTextField(
                        attribute: "isCompleted",
                        note: note,
                        viewModel: viewModel,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addNewNote,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class NoteTextField extends StatefulWidget {
  final String attribute;
  final Note note;
  final NoteListViewModel viewModel;

  const NoteTextField({
    super.key,
    required this.attribute,
    required this.note,
    required this.viewModel,
  });

  @override
  NoteTextFieldState createState() => NoteTextFieldState();
}

class NoteTextFieldState extends State<NoteTextField> {
  late TextEditingController editingController;
  late FocusNode focusNode;
  final NoteListViewModel viewModel = NoteListViewModel();
  bool isEditing = false; // Steuert, ob das Feld bearbeitet wird
  String? selectedValue; // Für Dropdown-Auswahl

  @override
  void initState() {
    super.initState();
    editingController = TextEditingController();
    focusNode = FocusNode();

    // Initialwert für Dropdown
    if (widget.attribute == "taskLength") {
      selectedValue = widget.viewModel.getAttribute(widget.note.id, "taskLength");
    } else if (widget.attribute == "eisenhowerCategory") {
      selectedValue = widget.viewModel.getAttribute(widget.note.id, "eisenhowerCategory");
    }

    // Listener hinzufügen, um den Fokusstatus zu überwachen
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        // Fokus verloren, Änderungen speichern und Bearbeitungsmodus beenden
        setState(() {
          isEditing = false;
        });
        widget.viewModel.updateNote(
          widget.note.id,
          widget.attribute,
          editingController.text,
        );
      }
    });
  }

  @override
  void dispose() {
    editingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String preText = "";
    late String hint;

    switch (widget.attribute) {
      case "title":
        preText = "Titel: ";
        hint = widget.viewModel.getAttribute(widget.note.id, "title") ?? "";
        break;
      case "description":
        preText = "Beschreibung: ";
        hint = widget.viewModel.getAttribute(widget.note.id, "description") ?? "";
        break;
      case "taskLength":
        preText = "Aufgabenlänge: ";
        hint = widget.viewModel.getAttribute(widget.note.id, "taskLength") ?? "";
        break;
      case "eisenhowerCategory":
        preText = "Eisenhower-Kategorie: ";
        hint = widget.viewModel.getAttribute(widget.note.id, "eisenhowerCategory") ?? "";
        break;
      case "createdAt":
        return Row(
          children: [
            Text(
              "Erstellt am:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              DateFormat('dd.MM.yyyy, hh:mm').format(widget.viewModel.getAttribute(widget.note.id, 'createdAt').toLocal()),
            ),
          ],
        );
      case "dueDate":
        preText = "Fällig am: ";
        final dueDate = widget.viewModel.getAttribute(widget.note.id, "dueDate");
        hint = dueDate != null
            ? DateFormat('dd.MM.yyyy, HH:mm').format(dueDate.toLocal())
            : "Kein Datum gesetzt";

        return Row(
          children: [
            Text(
              preText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  
                  // Datumsauswahl
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: dueDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (selectedDate != null && context.mounted) {
                    // Uhrzeitauswahl
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: dueDate != null
                          ? TimeOfDay.fromDateTime(dueDate)
                          : TimeOfDay.now(),
                    );

                    if (selectedTime != null && mounted) {
                      // Kombiniere Datum und Uhrzeit
                      final newDueDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );

                      // Aktualisiere die Notiz
                      setState(() {
                        widget.viewModel.updateNote(
                          widget.note.id,
                          "dueDate",
                          newDueDate.toIso8601String(),
                        );
                      });
                    }
                  }
                },
                child: Text(
                  hint,
                  style: const TextStyle(
                    color: Colors.blue, // Hebt den Text hervor
                    decoration: TextDecoration.underline, // Unterstreicht den Text
                  ),
                ),
              ),
            ),
          ],
        );
      case "tags":
        preText = "Tags: ";
        hint = widget.viewModel.getAttribute(widget.note.id, "tags").join(", ");
        break;
      case "isCompleted":
        preText = "Abgeschlossen: ";
        hint = widget.viewModel.getAttribute(widget.note.id, 'isCompleted') ? "Ja" : "Nein";
        break;
      default:
        preText = "";
    }

    // Dropdown für "taskLength" und "eisenhowerCategory"
    if (widget.attribute == "taskLength" || widget.attribute == "eisenhowerCategory") {
      final options = widget.attribute == "taskLength" ? taskLengthOptions : eisenhowerOptions;

      return Row(
        children: [
          Text(
            preText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedValue = newValue;
                });
                widget.viewModel.updateNote(
                  widget.note.id,
                  widget.attribute,
                  newValue!,
                );
              },
            ),
          ),
        ],
      );
    }

    // Standard-Textfeld für andere Attribute
    return Row(
      children: [
        Text(
          preText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: isEditing
              ? TextField(
                  controller: editingController..text = hint,
                  focusNode: focusNode,
                  onSubmitted: (value) {
                    widget.viewModel.updateNote(
                      widget.note.id,
                      widget.attribute,
                      value,
                    );
                    setState(() {
                      isEditing = false;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      isEditing = true;
                    });
                    focusNode.requestFocus();
                  },
                  child: Text(
                    hint,
                    style: const TextStyle(color: Colors.grey), // Grau darstellen
                  ),
                ),
        ),
      ],
    );
  }
}

