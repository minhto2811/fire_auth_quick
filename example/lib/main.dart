import 'package:fire_auth_quick/fire_auth_quick.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  login(OAuth oAuth) async {
    await FireAuthQuick.loginWithProvider(oAuth: oAuth);
  }

  link(OAuth oAuth) async {
    await FireAuthQuick.linkWithProvider(oAuth: oAuth);
  }

  signOut() async {
    await FireAuthQuick.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    login(OAuth.anonymous);
                  },
                  child: const Text('Login with Anonymous')),
              ElevatedButton(
                  onPressed: () {
                    login(OAuth.google);
                  },
                  child: const Text('Login with Google')),
              ElevatedButton(
                  onPressed: () {
                    login(OAuth.facebook);
                  },
                  child: const Text('Login with Facebook')),
              ElevatedButton(
                  onPressed: () {
                    login(OAuth.apple);
                  },
                  child: const Text('Login with Apple')),
              ElevatedButton(
                  onPressed: () {
                    link(OAuth.google);
                  },
                  child: const Text('Link with Google')),
              ElevatedButton(
                  onPressed: () {
                    link(OAuth.facebook);
                  },
                  child: const Text('Link with Facebook')),
              ElevatedButton(
                  onPressed: () {
                    link(OAuth.apple);
                  },
                  child: const Text('Link with Apple')),
              ElevatedButton(onPressed: signOut, child: const Text('Logout')),
            ],
          ),
        ),
      ),
    );
  }
}
