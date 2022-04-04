import 'package:flutter/material.dart';

class EmailSignInForm extends StatefulWidget {
  const EmailSignInForm({Key? key}) : super(key: key);
  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

enum EmailSignInFormType { signIn, register }

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  EmailSignInFormType formType = EmailSignInFormType.signIn;

  String get primaryText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
  }

  String get secondaryText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  void _onSubmit() {
    print(
        'email: $_emailController.text and password: $_passwordController.text');
  }

  void _toggleFormType() {
    setState(() {
      formType = formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });

    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'email@timetracker.com',
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _onSubmit,
              child: Text(
                primaryText,
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
              height: 40,
              child: TextButton(
                  onPressed: _toggleFormType,
                  child: Text(
                    secondaryText,
                    style: const TextStyle(fontSize: 14),
                  )))
        ],
      ),
    );
  }
}
