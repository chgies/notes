import 'package:flutter/material.dart';
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
      _editingController.selection = TextSelection.fromPosition(
        TextPosition(offset: _editingController.text.length),
      ); // Setzt den Cursor ans Ende des Textes
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notizen"),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: index == notes.length - 1 
              ? TextField(
                controller: _editingController,
                focusNode: _focusNode,
                onSubmitted: (value) {
                  setState(() {
                      viewModel.updateNote(note.id, "title", value); // Aktualisiert den Titel der Notiz
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Titel eingeben",
                  ),
                )
              : Text(note.title),
            subtitle: Text(note.description),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showOptions(note),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Ausgewählt: ${note.title}")),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}