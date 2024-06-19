import 'package:flutter/material.dart';

class ButtonAuth extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  const ButtonAuth({super.key, this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 35,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.purple,
      textColor: Colors.white,
      child: Text(title),
      onPressed: onPressed,
    );
  }
}

class ButtonAuthupload extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final bool isSelected;
  const ButtonAuthupload({super.key, this.onPressed, required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      minWidth: 200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: isSelected? Colors.green: Colors.purple,
      textColor: Colors.white,
      child: Text(title),
      onPressed: onPressed,
    );
  }
}
