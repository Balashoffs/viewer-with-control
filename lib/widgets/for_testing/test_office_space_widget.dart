import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:viewer_with_control/widgets/buttons/curtains_buttons.dart';
import 'package:viewer_with_control/widgets/buttons/lighting_buttons.dart';


class TestOpenSpaceControlWidget extends StatelessWidget {
  const TestOpenSpaceControlWidget({
    super.key,
    required this.name,
    required this.onLightingSwitch,
  });

  final String name;
  final Function(int, bool) onLightingSwitch;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'NunitoSans-Bold',
              color: Colors.deepPurple,
              fontSize: 18,
            ),
          ),
        ),
        Column(
          children: [
            SvgPicture.asset(
              'assets/svg/lighting.svg',
              fit: BoxFit.fitWidth,
            ),

            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                LightingButton(
                  onChanged: (state) => onLightingSwitch(1, state),
                ),
                LightingButton(
                  onChanged: (state) => onLightingSwitch(2, state),
                ),
                LightingButton(
                  onChanged: (state) => onLightingSwitch(3, state),
                ),
                LightingButton(
                  onChanged: (state) => onLightingSwitch(4, state),
                ),
              ],
            ),

          ],
        )
      ],
    );
  }
}