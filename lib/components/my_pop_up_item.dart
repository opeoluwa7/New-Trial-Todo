import 'package:flutter/material.dart';

class MyPopUpItem extends StatelessWidget {
  const MyPopUpItem({super.key, required this.text, this.onPressed});
  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return PopupMenuItem(
        child: TextButton(onPressed: onPressed, child: Text(text)));
  }
}
