import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class LightingButton extends StatelessWidget {
  const LightingButton({super.key, required this.onChanged});

  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: 48,
        child: LiteRollingSwitch(
          value: false,
          textOn: 'вкл',
          textOff: 'выкл',
          textOnColor: Colors.white,
          colorOn: Colors.deepPurple,
          colorOff: Colors.grey,
          iconOn: Icons.light_rounded,
          iconOff: Icons.light_outlined,
          animationDuration: const Duration(milliseconds: 300),
          onChanged: onChanged,
          onDoubleTap: () {},
          onSwipe: () {},
          onTap: () {},
        ),
      ),
    );
  }
}