import 'dart:async';
import 'dart:convert';

import 'package:viewer_with_control/models/ws/ws_message.dart';
import 'package:web_socket_client/web_socket_client.dart';

import 'viewer_web_socket_client.dart';

class ViewerWebSocketService {
  final ViewerWebSocketClient _socketClient;

  ViewerWebSocketService(String host, int port)
      :_socketClient = ViewerWebSocketClient(host, port){
    _socketClient.state.listen(_handleConnectionState);
  }


  late StreamController<OpcMessage> _streamController;

  Stream<OpcMessage> get event => _streamController.stream;

  StreamSink<OpcMessage> get sink => _streamController.sink;


  void _handleConnectionState(ConnectionState state){
    if (state is Connecting || state is Reconnecting) {
      _streamController = StreamController();
    } else if (state is Reconnected || state is Connected) {
      event.listen(_handleActionMessage);
    } else {
      _streamController.close();
    }
  }

  void _handleActionMessage(OpcMessage message){
    print('_handleActionMessage::Incoming message: $message');
    String json = jsonEncode(message.toMap());
    _socketClient.send(json);
  }


  void close() {
    _socketClient.dispose();
  }
}