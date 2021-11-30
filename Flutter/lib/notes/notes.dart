import 'package:flutter/material.dart';
import 'package:assistantmemo/services/auth.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ElevatedButton(
          child: Text('signout'),
          onPressed: () async {
            await AuthService().signOut();
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false);
          }),
    );
  }
}
