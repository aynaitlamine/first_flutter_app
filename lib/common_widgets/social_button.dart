import 'package:first_flutter_app/common_widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class SignInSocial extends CustomElevatedButton {
  SignInSocial(
      {Key? key,
      String? text,
      String? image,
      Color? color,
      Color? textColor,
      double borderRadius = 4.0,
      VoidCallback? onPressed})
      : super(
            key: key,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(image ?? ''),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                Text(
                  text ?? 'error',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                Opacity(
                  opacity: 0.0,
                  child: Image.asset(image ?? ''),
                ),
              ],
            ),
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                primary: color,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(borderRadius)))));
}
