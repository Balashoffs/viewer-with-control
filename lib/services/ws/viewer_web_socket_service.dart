import 'dart:async';

import 'package:viewer_with_control/models/viewer_mqqt_message.dart';

import 'viewer_web_socket_client.dart';

class ViewerWebSocketService {
  final ViewerWebSocketClient _socketClient;

  ViewerWebSocketService(String host, int port)
      :_socketClient = ViewerWebSocketClient(),
        _streamController = StreamController();

  late StreamController<ActionMessage> _streamController;

  Stream<ActionMessage> get stream => _streamController.stream;

  StreamSink<ActionMessage> get sink => _streamController.sink;

  void init() {

  }

  void close() {

  }
}