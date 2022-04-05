import 'dart:developer';
import 'package:first_flutter_app/screens/email_signin_screen.dart';
import 'package:first_flutter_app/services/auth.dart';
import 'package:first_flutter_app/widgets/signin_button.dart';
import 'package:first_flutter_app/widgets/social_button.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key, required this.auth}) : super(key: key);

  final AuthBase auth;

  Future<void> _signAnonymously() async {
    try {
      await auth.signInAnonymously();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      log(e.toString());
    }
  }

  void _signWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSingIn(
              auth: auth,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time tracker'),
        elevation: 2.0,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Sign In',
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              SignInSocial(
                onPressed: _signInWithGoogle,
                text: 'Sign in with google',
                color: Colors.white,
                textColor: Colors.black87,
                image: 'images/google-logo.png',
              ),
              const SizedBox(height: 10.0),
              SignInSocial(
                onPressed: () {},
                text: 'Sign in with facebook',
                color: const Color(0xFF334D92),
                textColor: Colors.white,
                image: 'images/facebook-logo.png',
              ),
              const SizedBox(height: 10.0),
              SignInButton(
                onPressed: () => _signWithEmail(context),
                text: 'Sign in with email',
                color: Colors.teal[700],
                textColor: Colors.white,
              ),
              const SizedBox(height: 10.0),
              const Text(
                'or',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10.0),
              SignInButton(
                onPressed: _signAnonymously,
                text: 'Continue anonymous',
                color: Colors.lime[300],
                textColor: Colors.black87,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
