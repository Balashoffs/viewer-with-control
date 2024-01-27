import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import 'widgets/ifc_viewer_widget.dart';

final localhostServer = InAppLocalhostServer(documentRoot: 'assets/viewer');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  if (!kIsWeb) {
    await localhostServer.start();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            OpenSpaceControlWidget(
                              name: 'Пространство',
                              onCurtainsDown: () {},
                              onCurtainsUp: () {},
                              onLightingSwitch: (state) {},
                            ),
                            SizedBox(
                              height: 36,
                            ),
                            OpenSpaceControlWidget(
                              name: 'Кабинет',
                              onCurtainsDown: () {},
                              onCurtainsUp: () {},
                              onLightingSwitch: (state) {},
                            ),
                          ],
                        ),
                      ),
                      // fit: FlexFit.loose,
                    ),
                    Flexible(
                      child: IfcViewerWidget(),
                      flex: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

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

class CurtainsButton extends StatelessWidget {
  const CurtainsButton(
      {super.key, required this.onPressed, required this.icon});

  final Function() onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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

class LightingButton extends StatelessWidget {
  const LightingButton({super.key, required this.onChanged});

  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        height: 48,
        child: LiteRollingSwitch(
          value: false,
          textOn: '',
          textOff: '',
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
