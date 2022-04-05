import 'package:first_flutter_app/services/auth.dart';
import 'package:first_flutter_app/widgets/email_signin_form.dart';
import 'package:flutter/material.dart';

class EmailSingIn extends StatelessWidget {
  const EmailSingIn({Key? key, required this.auth}) : super(key: key);

  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Sign'),
        elevation: 2.0,
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            reverse: true,
            child: Card(
              child: EmailSignInForm(
                auth: auth,
              ),
            ),
          )),
    );
  }
}
