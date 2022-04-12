import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter_app/bloc/sign_in_bloc.dart';
import 'package:first_flutter_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:first_flutter_app/screens/email_signin_screen.dart';
import 'package:first_flutter_app/common_widgets/signin_button.dart';
import 'package:first_flutter_app/common_widgets/social_button.dart';
import 'package:first_flutter_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key, required this.bloc}) : super(key: key);

  final SignInBloc bloc;
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(auth: auth),
      child: Consumer<SignInBloc>(builder: (_, bloc, __) => SignIn(bloc: bloc)),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  Future<void> _signAnonymously(BuildContext context, bool isLoading) async {
    try {
      await bloc.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, title: 'Sign in failed', exception: e);
    } finally {}
  }

  Future<void> _signInWithGoogle(BuildContext context, bool isLoading) async {
    try {
      await bloc.signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, title: 'Sign in failded', exception: e);
    } finally {}
  }

  void _signWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        fullscreenDialog: true, builder: (context) => const EmailSingIn()));
  }

  Widget _buildHeader(isLoading) {
    if (isLoading) {
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

  Widget _buildContent(BuildContext context, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildHeader(isLoading),
          const SizedBox(height: 20.0),
          // Sign in with google
          SignInSocial(
            onPressed:
                isLoading ? null : () => _signInWithGoogle(context, isLoading),
            text: 'Sign in with google',
            color: Colors.white,
            textColor: Colors.black87,
            image: 'images/google-logo.png',
          ),
          const SizedBox(height: 10.0),
          //Sign in with facebook
          SignInSocial(
            onPressed: () {},
            text: 'Sign in with facebook',
            color: const Color(0xFF334D92),
            textColor: Colors.white,
            image: 'images/facebook-logo.png',
          ),
          const SizedBox(height: 10.0),
          //Sign in with email and password
          SignInButton(
            onPressed: isLoading ? null : () => _signWithEmail(context),
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
          //Sign in with anonymously
          SignInButton(
            onPressed:
                isLoading ? null : () => _signAnonymously(context, isLoading),
            text: 'Continue anonymous',
            color: Colors.lime[300],
            textColor: Colors.black87,
          ),
          const SizedBox(height: 10.0),
        ],
      ),
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
      body: StreamBuilder<bool>(
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (context, snapshot) {
            return _buildContent(context, snapshot.data!);
          }),
      backgroundColor: Colors.grey[200],
    );
  }
}
