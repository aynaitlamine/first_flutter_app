import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter_app/bloc/email_signin_bloc.dart';
import 'package:first_flutter_app/common_widgets/email_signin_model.dart';
import 'package:first_flutter_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:first_flutter_app/common_widgets/signin_button.dart';
import 'package:first_flutter_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailSignInFormBlock extends StatefulWidget {
  const EmailSignInFormBlock({Key? key, required this.bloc}) : super(key: key);

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

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, title: 'Sign in failed', exception: e);
    }
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'email@timetracker.com',
          errorText: model.emailErrorText,
          enabled: model.isLoading == false),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingComplete(model),
      onChanged: (email) => widget.bloc.updateEmail(email),
    );
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          labelText: 'Password',
          errorText: model.passwordErrorText,
          enabled: model.isLoading == false),
      obscureText: true,
      onChanged: (password) => widget.bloc.updatePassword(password),
      onEditingComplete: _submit,
    );
  }

  List<Widget> _buildChildren(EmailSignInModel? model) {
    return [
      _buildEmailTextField(model!),
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
                  text: model.primaryButtonText,
                  textColor: Colors.white,
                  onPressed: model.canSubmit ? _submit : null),
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
            onPressed: !model.isLoading ? _toggleFormType : null,
            child: Text(
              model.secondaryButtonText,
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
