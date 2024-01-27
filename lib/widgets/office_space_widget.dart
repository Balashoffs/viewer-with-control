import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:viewer_with_control/widgets/buttons/curtains_buttons.dart';
import 'package:viewer_with_control/widgets/buttons/lighting_buttons.dart';


class OpenSpaceControlWidget extends StatelessWidget {
  const OpenSpaceControlWidget({
    super.key,
    required this.name,
    required this.onCurtainsUp,
    required this.onCurtainsDown,
    required this.onLightingSwitch,
  });

  final String name;
  final VoidCallback onCurtainsUp;
  final VoidCallback onCurtainsDown;
  final Function(bool) onLightingSwitch;

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
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SvgPicture.asset('assets/svg/curtains.svg'),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                CurtainsButton(
                  icon: const Icon(Icons.arrow_upward),
                  onPressed: onCurtainsUp,
                ),
                CurtainsButton(
                  icon: const Icon(Icons.arrow_downward),
                  onPressed: onCurtainsDown,
                ),
              ],
            ),
            SvgPicture.asset(
              'assets/svg/lighting.svg',
              fit: BoxFit.fitWidth,
            ),
            LightingButton(
              onChanged: onLightingSwitch,
            ),
          ],
        )
      ],
    );
  }
}