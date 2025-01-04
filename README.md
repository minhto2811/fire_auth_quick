

# FireAuthQuick Plugin

**FireAuthQuick Plugin** is a Flutter plugin that simplifies user authentication using Google, Facebook, Apple, and Anonymous methods, enabling a seamless login experience with minimal setup.

## 🚀 Features
- **Google Authentication**: Sign in using Google account.
- **Facebook Authentication**: Log in with a Facebook account.
- **Apple Authentication**: Enable sign-in with Apple ID.
- **Anonymous Authentication**: Provide authentication without the need for an account.
- **Quick and Easy Integration**: Set up in just a few steps.

## 📦 Installation
Add the plugin to your `pubspec.yaml` file:

```yaml
fire_auth_quick: <latest-version>
```  

Then run:

```bash
flutter pub get
```  

## ⚙️ Configuration
Create a Firebase project and enable Google, Facebook, Apple, and Anonymous sign-in methods from the [Firebase Console](https://console.firebase.google.com) - [Add Firebase to your Flutter app](https://firebase.google.com/docs/flutter/setup).

For Google authenticate, follow the instructions from the [google_sign_in](https://pub.dev/packages/google_sign_in).

For Facebook authentication, follow the instructions from the [flutter_facebook_auth](https://pub.dev/packages/flutter_facebook_auth).

For Apple authentication, follow the setup guide from the [Apple Developer Portal](https://developer.apple.com).

## 🔧 Usage

```dart
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

  logOut() async {
    await FireAuthQuick.logOut();
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
              ElevatedButton(onPressed: logOut, child: const Text('Logout')),
            ],
          ),
        ),
      ),
    );
  }
}

```  

## 🛠️ Contribution
We welcome contributions from the community. Feel free to submit a pull request or create an issue if you encounter any bugs.

## 📄 License
MIT License - Feel free to use and modify as needed.

---  

**Made with ❤️ by mxgk**