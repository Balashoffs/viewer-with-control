import 'package:flutter/material.dart';

class CurtainsButton extends StatelessWidget {
  const CurtainsButton(
      {super.key, required this.onPressed, required this.icon});

  final Function() onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: 130,
        child: ElevatedButton(
          onPressed: onPressed,
          child: icon,
        ),
      ),
    );
  }
}