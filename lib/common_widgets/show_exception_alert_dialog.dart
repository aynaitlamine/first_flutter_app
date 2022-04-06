import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter_app/common_widgets/show_alert_dialog.dart';
import 'package:flutter/widgets.dart';

Future<void> showExceptionAlertDialog(
  BuildContext context, {
  required String title,
  required Exception exception,
}) =>
    showAlertDialog(context,
        title: title, content: _message(exception), defaultActionText: 'OK');

String _message(Exception exception) {
  if (exception is FirebaseAuthException) {
    return exception.message ?? 'error';
  }

  return exception.toString();
}
