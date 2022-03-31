import 'package:first_flutter_app/widgets/signin_butoon.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

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
            SignInButton(
              onPressed: () {},
              text: 'Sign in with google',
              color: Colors.white,
              textColor: Colors.black87,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
