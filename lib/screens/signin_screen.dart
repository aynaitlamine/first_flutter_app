import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter_app/widgets/signin_button.dart';
import 'package:first_flutter_app/widgets/social_button.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  Future<void> _signAnonymously() async {
    try {
      final userCredentials = await FirebaseAuth.instance.signInAnonymously();
      print(userCredentials.user);
    } catch (e) {
      print(e.toString());
    }
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
              onPressed: () {},
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
              onPressed: () {},
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
      backgroundColor: Colors.grey[200],
    );
  }
}
