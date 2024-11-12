import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  // this step is required to initialize Firebase so that it can actually
  // start the to and fro authentication of data
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 144, 18, 18)),
      useMaterial3: true,
    ),
    home: const HomePage(),
  ));
}

// creating a stateless widget with just a container in it whose
// color we can change on command
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shivam's app"),
      ),
      // Basically, the text
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: 'Please enter your email'),
          ),
          TextField(
            controller: _password,
            //used to obscure the field and not take suggestions
            //or have autocorrect on
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                InputDecoration(hintText: 'Please choose your password'),
          ),
          TextButton(
              onPressed: () async {
                // the text property of the TextController is needed to transer
                // the text
                // The variables are declared as final so that their value
                // is assigned at runtime, and does not change again
                final email = _email.text;
                final password = _password.text;

                //we have to put await in front of the FirebaseAuth function
                //because this is something that will complete in the future
                //and we have to wait till the time it does not
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email, password: password);
              },
              child: const Text('Register')),
        ],
      ),
    );
  }
}
