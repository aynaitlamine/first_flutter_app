import 'dart:async';

import 'package:first_flutter_app/common_widgets/email_signin_model.dart';
import 'package:first_flutter_app/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});
  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  Future<void> onSubmit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      Future.delayed(const Duration(seconds: 3));
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email!, _model.password!);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email!, _model.password!);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateWith(
      {String? email,
      String? password,
      EmailSignInFormType? formType,
      bool? isLoading,
      bool? submitted}) {
    _model = _model.copyWith(
        email: email,
        password: password,
        formType: formType,
        isLoading: isLoading,
        submitted: submitted);

    _modelController.add(_model);
  }
}
