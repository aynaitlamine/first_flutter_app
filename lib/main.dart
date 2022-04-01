import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_flutter_app/screens/signin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Time tracker',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const SignIn());
  }
}
