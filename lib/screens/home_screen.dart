import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter_app/common_widgets/show_alert_dialog.dart';
import 'package:first_flutter_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:first_flutter_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  Future<void> _signOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, title: 'Sign out failed', exception: e);
    }
  }

  Future<void> _signOutConfirm(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Sign out',
        content: 'Are you sure you want to sign out?',
        defaultActionText: 'OK',
        cancelActionText: 'Cancel');

    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton(
            onPressed: () => _signOutConfirm(context),
            child: const Text(
              'logout',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
