import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:viewer_with_control/repository/viewer_device_control_repository.dart';
import 'package:viewer_with_control/widgets/enable_remote_control_widget.dart';
import 'package:viewer_with_control/widgets/office_space_widget.dart';

import 'bloc/viewer_page_cubit.dart';
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
  late ViewerDeviceControlRepository _deviceControlRepository;

  @override
  void initState() {
    super.initState();
    _deviceControlRepository = ViewerDeviceControlRepository();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _deviceControlRepository,
      child: BlocProvider(
        create: (context) => ViewerPageCubit(_deviceControlRepository)..init(),
        child: SafeArea(
          child: Scaffold(
            body: MainPage(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    context.read<ViewerDeviceControlRepository>().stop();
    super.dispose();
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<ViewerPageCubit, ViewerPageState>(
              builder: (context, state) {
                if (state.status == ViewerPageStatus.loading) {
                  return Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 128,
                              child: Text(
                                'Иницилизация управления стендом',
                                maxLines: 3,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'NunitoSans-Bold',
                                  color: Colors.deepPurple,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(height: 48,),
                            CircularProgressIndicator(
                              backgroundColor: Colors.deepPurple,
                              color: Colors.deepPurple.shade50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        EnableRemoteControlWidget(
                          icRemote: (isChecked) async{
                            context
                                .read<ViewerDeviceControlRepository>()
                                .switchRemoteControl(isChecked);
                          },
                        ),
                        const Divider(
                          height: 20,
                          thickness: 2,
                          indent: 0,
                          endIndent: 0,
                          color: Colors.deepPurple,
                        ),
                        OpenSpaceControlWidget(
                          name: 'Пространство',
                          onCurtainsDown: () async{
                            context
                                .read<ViewerDeviceControlRepository>()
                                .downCurtainsOne();
                          },
                          onCurtainsUp: () async{
                            context
                                .read<ViewerDeviceControlRepository>()
                                .upCurtainsOne();
                          },
                          onLightingSwitch: (state)async {
                            context
                                .read<ViewerDeviceControlRepository>()
                                .switchLightOne(state);
                          },
                        ),
                        SizedBox(
                          height: 36,
                        ),
                        OpenSpaceControlWidget(
                          name: 'Кабинет',
                          onCurtainsDown: () async{
                            context
                                .read<ViewerDeviceControlRepository>()
                                .downCurtainsTwo();
                          },
                          onCurtainsUp: () async{
                            context
                                .read<ViewerDeviceControlRepository>()
                                .upCurtainsTwo();
                          },
                          onLightingSwitch: (state) async{
                            context
                                .read<ViewerDeviceControlRepository>()
                                .switchLightTwo(state);
                          },
                        ),
                      ],
                    ),
                  ),
                  // fit: FlexFit.loose,
                );
              },
            ),
            Flexible(
              child: IfcViewerWidget(),
              flex: 12,
            ),
          ],
        ),
      ),
    );
  }
}
