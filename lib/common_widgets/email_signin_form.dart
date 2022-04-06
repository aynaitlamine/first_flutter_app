import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:first_flutter_app/helpers/validators.dart';
import 'package:first_flutter_app/common_widgets/signin_button.dart';
import 'package:first_flutter_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
  EmailSignInForm({Key? key}) : super(key: key);
  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

enum EmailSignInFormType { signIn, register }

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      Future.delayed(const Duration(seconds: 3));
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, title: 'Sign in failed', exception: e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _submitted = _isLoading ? true : false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });

    _emailController.clear();
    _passwordController.clear();
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  TextField _buildEmailTextField() {
    bool showErrorText =
        _submitted && !widget.emailValidator.isValid(_password) && !_isLoading;

    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'email@timetracker.com',
          errorText: showErrorText ? widget.invalidEmailErrorText : null,
          enabled: _isLoading == false),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
      onChanged: (email) => _updateState(),
    );
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);

    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          labelText: 'Password',
          errorText: showErrorText ? widget.invalidPasswordErrorText : null,
          enabled: _isLoading == false),
      obscureText: true,
      onChanged: (email) => _updateState(),
    );
  }

  void _updateState() {
    setState(() {});
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    return [
      _buildEmailTextField(),
      const SizedBox(
        height: 8,
      ),
      _buildPasswordTextField(),
      const SizedBox(
        height: 20,
      ),
      !_isLoading
          ? SizedBox(
              height: 50,
              child: SignInButton(
                  text: primaryText,
                  textColor: Colors.white,
                  onPressed: submitEnabled ? _onSubmit : null),
            )
          : const SizedBox(
              child: SizedBox(
                height: 60.0,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
      const SizedBox(
        height: 8,
      ),
      SizedBox(
        height: 40,
        child: TextButton(
            onPressed: !_isLoading ? _toggleFormType : null,
            child: Text(
              secondaryText,
              style: const TextStyle(fontSize: 14),
            )),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildChildren()),
    );
  }
}
