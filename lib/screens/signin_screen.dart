import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:first_flutter_app/screens/email_signin_screen.dart';
import 'package:first_flutter_app/common_widgets/signin_button.dart';
import 'package:first_flutter_app/common_widgets/social_button.dart';
import 'package:first_flutter_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isLoading = false;

  Future<void> _signAnonymously(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      setState(() => _isLoading = true);
      await auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, title: 'Sign in failed', exception: e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      setState(() => _isLoading = true);
      await auth.signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, title: 'Sign in failded', exception: e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _signWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        fullscreenDialog: true, builder: (context) => const EmailSingIn()));
  }

  SignInSocial _buildSignInWithGoogle() {
    return SignInSocial(
      onPressed: _isLoading ? null : () => _signInWithGoogle(context),
      text: 'Sign in with google',
      color: Colors.white,
      textColor: Colors.black87,
      image: 'images/google-logo.png',
    );
  }

  SignInSocial _buildSignInWithFacebook() {
    return SignInSocial(
      onPressed: () {},
      text: 'Sign in with facebook',
      color: const Color(0xFF334D92),
      textColor: Colors.white,
      image: 'images/facebook-logo.png',
    );
  }

  SignInButton _buildSignInWithEmail() {
    return SignInButton(
      onPressed: _isLoading ? null : () => _signWithEmail(context),
      text: 'Sign in with email',
      color: Colors.teal[700],
      textColor: Colors.white,
    );
  }

  SignInButton _buildSignAnonymously() {
    return SignInButton(
      onPressed: _isLoading ? null : () => _signAnonymously(context),
      text: 'Continue anonymous',
      color: Colors.lime[300],
      textColor: Colors.black87,
    );
  }

  Widget _buildHeader() {
    if (_isLoading) {
      return const SizedBox(
        child: SizedBox(
          height: 60.0,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return const Text(
      'Sign In',
      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
    );
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
            _buildHeader(),
            const SizedBox(height: 20.0),
            //Sign in with google
            _buildSignInWithGoogle(),
            const SizedBox(height: 10.0),
            //Sign in with facebook
            _buildSignInWithFacebook(),
            const SizedBox(height: 10.0),
            //Sign in with email and password
            _buildSignInWithEmail(),
            const SizedBox(height: 10.0),
            const Text(
              'or',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            //Sign in with anonymously
            _buildSignAnonymously(),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
