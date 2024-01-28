import 'package:flutter/material.dart';

class EnableRemoteControlWidget extends StatefulWidget {
  const EnableRemoteControlWidget({super.key, required this.icRemote});

  final Function(bool) icRemote;

  @override
  State<EnableRemoteControlWidget> createState() =>
      _EnableRemoteControlWidgetState();
}

class _EnableRemoteControlWidgetState extends State<EnableRemoteControlWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 96,
          child: Text(
            'Удаленное управление',
            maxLines: 2,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'NunitoSans-Bold',
              color: Colors.deepPurple,
              fontSize: 14,
            ),
          ),
        ),
        Checkbox(
          activeColor: Colors.deepPurple,
          checkColor: Colors.white,
          value: isChecked,
          onChanged: (bool? value) {
            isChecked = value!;
            widget.icRemote(value);
            setState(() {});
          },
        ),
      ],
    );
  }
}
