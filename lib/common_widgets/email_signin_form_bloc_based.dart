import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter_app/bloc/email_signin_bloc.dart';
import 'package:first_flutter_app/common_widgets/email_signin_model.dart';
import 'package:first_flutter_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:first_flutter_app/helpers/validators.dart';
import 'package:first_flutter_app/common_widgets/signin_button.dart';
import 'package:first_flutter_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailSignInFormBlock extends StatefulWidget
    with EmailAndPasswordValidators {
  EmailSignInFormBlock({Key? key, required this.bloc}) : super(key: key);

  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
          builder: (_, bloc, __) => EmailSignInFormBlock(bloc: bloc)),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  State<EmailSignInFormBlock> createState() => _EmailSignInFormBlockState();
}

enum EmailSignInFormType { signIn, register }

class _EmailSignInFormBlockState extends State<EmailSignInFormBlock> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    try {
      await widget.bloc.onSubmit();

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, title: 'Sign in failed', exception: e);
    }
  }

  void _toggleFormType(EmailSignInModel model) {
    final formType = model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;

    widget.bloc.updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );

    _emailController.clear();
    _passwordController.clear();
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = widget.emailValidator.isValid(model.email!)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    bool showErrorText = model.submitted &&
        !widget.emailValidator.isValid(model.password!) &&
        model.isLoading;

    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'email@timetracker.com',
          errorText: showErrorText ? widget.invalidEmailErrorText : null,
          enabled: model.isLoading == false),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingComplete(model),
    );
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    bool showErrorText =
        model.submitted && !widget.passwordValidator.isValid(model.password!);

    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          labelText: 'Password',
          errorText: showErrorText ? widget.invalidPasswordErrorText : null,
          enabled: model.isLoading == false),
      obscureText: true,
    );
  }

  List<Widget> _buildChildren(EmailSignInModel? model) {
    final primaryText = model!.formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final secondaryText = model.formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';

    bool submitEnabled = widget.emailValidator.isValid(model.email!) &&
        widget.passwordValidator.isValid(model.password!) &&
        !model.isLoading;

    return [
      _buildEmailTextField(model),
      const SizedBox(
        height: 8,
      ),
      _buildPasswordTextField(model),
      const SizedBox(
        height: 20,
      ),
      !model.isLoading
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
            onPressed: !model.isLoading ? () => _toggleFormType(model) : null,
            child: Text(
              secondaryText,
              style: const TextStyle(fontSize: 14),
            )),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel? model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildChildren(model)),
          );
        });
  }
}
