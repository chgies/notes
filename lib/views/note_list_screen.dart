//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../viewmodels/note_list_viewmodel.dart';
import '../models/note.dart';

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
  //            title: Text(viewModel.getAttribute(note.id, "title")),
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

class NoteTextField extends StatelessWidget {
  final String attribute;
  final Note note;
  final NoteListViewModel viewModel;
  final TextEditingController editingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  NoteTextField({
    super.key,
    required this.attribute,
    required this.note,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {

    // Hier wird der Text des Textfeldes gesetzt    
    String preText = "";
    late String hint;
    switch (attribute) {
      case "title":
        preText = "Titel: ";
        hint = "${viewModel.getAttribute(note.id, "title")}";
        break;
      case "description":
        preText = "Beschreibung";
        hint = "${viewModel.getAttribute(note.id, "description")}";
        break;
      case "taskLength":
        preText = "Aufgabenlänge";
        hint = "${viewModel.getAttribute(note.id, "taskLength")}";
        break;
      case "eisenhowerCategory":
        preText = "Eisenhower-Kategorie";
        hint = "${viewModel.getAttribute(note.id, "eisenhowerCategory")}";
        break;
      case "createdAt":
        return Row(children: [
          Text(
            "Erstellt am:",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "${DateFormat('dd.MM.yyyy, hh:mm').format(viewModel.getAttribute(note.id, 'createdAt').toLocal())}",
          )
        ],
        );
        case "dueDate":
        preText = "Fällig am:";
        hint = "${DateFormat('dd.MM.yyyy, hh:mm').format(viewModel.getAttribute(note.id, 'dueDate').toLocal())}";
        break;
      case "tags":
        preText = "Tags:";
        hint = "${viewModel.getAttribute(note.id, "tags").join(", ")}";
        break;
      case "isCompleted":
        preText = "Abgeschlossen:";
        hint = viewModel.getAttribute(note.id, 'isCompleted') ? "Ja" : "Nein";
        break;
      default:
        preText = "";
    }

    return Row(
      children: [
        Text(
          preText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        IntrinsicWidth(
          child: TextField(
            controller: editingController,
            focusNode: focusNode,
            onSubmitted: (value) {
              viewModel.updateNote(note.id, attribute, value); // Aktualisiert das Attribut der Notiz
            },
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            ),
          ),
        )
      ]    
    );
  }
}

