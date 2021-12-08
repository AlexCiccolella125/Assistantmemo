import 'package:assistantmemo/services/models.dart';
import 'package:flutter/material.dart';
import 'package:assistantmemo/shared/BottomNavBar.dart';
import 'package:assistantmemo/services/serverAPI.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Note>>(
      // Initialize FlutterFire:
      future: FirestoreService().listNotes(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData) {
          var notes = snapshot.data!;
          return ListOfNotes(notes: notes);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('loading', textDirection: TextDirection.ltr);
        } else {
          return Text(
              "Really strange error, there might be missing data in DB");
        }
      },
    );
  }
}

class ListOfNotes extends StatelessWidget {
  const ListOfNotes({
    Key? key,
    required this.notes,
  }) : super(key: key);

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('notes'),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20.0),
        crossAxisCount: 1,
        crossAxisSpacing: 1,
        mainAxisSpacing: 100,
        children: notes.map((note) => Text(note.text_transcript)).toList(),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
