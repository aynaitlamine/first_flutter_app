import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter_app/screens/home_screen.dart';
import 'package:first_flutter_app/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter_app/services/auth.dart';

class Landing extends StatelessWidget {
  const Landing({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            if (user == null) {
              return SignIn(
                auth: auth,
              );
            }
            return Home(
              auth: auth,
            );
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        });
  }
}
