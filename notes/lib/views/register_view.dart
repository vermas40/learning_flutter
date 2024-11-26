import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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

  // every widget needs to have a build function and this is where we
  // define the different components and how these components will function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shivam's app"),
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
                return Column(
                  children: [
                    TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: 'Please enter your email'),
                    ),
                    TextField(
                      controller: _password,
                      //used to obscure the field and not take suggestions
                      //or have autocorrect on
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                          hintText: 'Please choose your password'),
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
                          try {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: email, password: password);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              print('Create a stronger password');
                            } else if (e.code == 'email-already-in-use') {
                              print('Already an account with this');
                            } else {
                              print(e);
                            }
                          }
                        },
                        child: const Text('Register')),
                  ],
                );
              default:
                return const Text('Loading...');
            }
          }),
    );
  }
}
