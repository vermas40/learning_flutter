// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text("Login View"),
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
                            // building in exception handling to handle cases
                            // in which the registering user was not found and
                            // all
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email, password: password);
                            // below code is for capturing a specific exception only
                          } on FirebaseAuthException catch (e) {
                            print('This is the exception you caught');
                            // This is how we can capture specific exceptions
                            // inside the exceptions code
                            if (e.code == 'invalid-credential') {
                              print(
                                  'This is an invalid credential you have put');
                            }
                            // this is a catch-all block
                          } catch (e) {
                            print('Somthing bad happened');
                            print(e);
                            print(e.runtimeType);
                          }
                        },
                        child: const Text('Login')),
                  ],
                );
              default:
                return const Text('Loading...');
            }
          }),
    );
  }
}
