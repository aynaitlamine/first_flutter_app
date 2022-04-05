import 'package:first_flutter_app/services/auth.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

class AuthProvider extends InheritedWidget {
  const AuthProvider({
    Key? key,
    required this.child,
    required this.auth,
  }) : super(key: key, child: child);

  final AuthBase auth;

  @override
  // ignore: overridden_fields
  final Widget child;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static AuthBase of(BuildContext context) {
    AuthProvider? provider =
        context.dependOnInheritedWidgetOfExactType<AuthProvider>();

    return provider!.auth;
  }
}
