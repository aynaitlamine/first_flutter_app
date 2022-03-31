import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {Key? key, this.child, this.style, this.height = 50.0, this.onPressed})
      : super(key: key);

  final Widget? child;
  final ButtonStyle? style;
  final double height;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        child:
            ElevatedButton(onPressed: onPressed, style: style, child: child));
  }
}
