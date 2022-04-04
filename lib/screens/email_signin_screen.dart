import 'package:first_flutter_app/widgets/email_signin_form.dart';
import 'package:flutter/material.dart';

class EmailSingIn extends StatelessWidget {
  const EmailSingIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Sign'),
        elevation: 2.0,
        centerTitle: true,
      ),
      body: const Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            reverse: true,
            child: Card(
              child: EmailSignInForm(),
            ),
          )),
    );
  }
}
