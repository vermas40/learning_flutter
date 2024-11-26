import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/views/login_view.dart';

void main() async {
  // this statement is used to ensure Flutter platform is properly initialized
  // before we start using services that depend on it e.g. Async operations
  // or using packages like FireBase
  WidgetsFlutterBinding.ensureInitialized();
  // this step is required to initialize Firebase so that it can actually
  // start the to and fro authentication of data
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 144, 18, 18)),
      useMaterial3: true,
    ),
    // this will return the view that is passed on here as a homepage
    home: const HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      //FutureBuilder is like the observeEvent
      // the rest of the code will not work till the time this
      // whatever the FutureBuilder is supposed to be building does not
      // finish
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            // snapshot handles the execution till the time
            // it is not done executing
            // we can use it to show snapshots or text till the time
            // that is done
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                print(user);
                //the user variable in itself can be null because the user
                //may not be logged in at all. To deal with such scenarios
                //we would need to handle for the variable being null
                //we would need to use coalesce like the way we do it in sql
                if (user?.emailVerified ?? false) {
                  print('Your email is verified');
                } else {
                  print('Your email is not verified');
                }
                return const Text('Done');
              default:
                return const Text('Loading...');
            }
          }),
    );
  }
}
