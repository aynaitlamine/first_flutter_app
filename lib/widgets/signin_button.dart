import 'package:first_flutter_app/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton(
      {Key? key,
      String? text,
      Color? color,
      Color? textColor,
      double borderRadius = 4.0,
      VoidCallback? onPressed})
      : super(
            key: key,
            child: Text(
              text ?? 'error',
              style:
                  TextStyle(color: textColor ?? Colors.black87, fontSize: 14),
            ),
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                primary: color,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(borderRadius)))));
}
