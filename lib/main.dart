import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_auth/components/ErrorMessage.dart';
import 'package:loading/loading.dart';

import 'app.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return ErrorMsg(
            title: Text("Flutter Connection Error"),
            content: Text("There is an error connecting to Firebase")
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyAwesomeApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}