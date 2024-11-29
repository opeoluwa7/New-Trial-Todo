import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MySlidableItem extends StatelessWidget {
  const MySlidableItem(
      {super.key, required this.icon, this.onPressed, required this.color, required this.labelText});
  final IconData icon;
  final void Function(BuildContext)? onPressed;
  final Color color;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      label: labelText,
      //padding: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: color,
      onPressed: onPressed,
      icon: icon,
    );
  }
}
