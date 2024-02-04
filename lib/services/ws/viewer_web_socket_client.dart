import 'package:web_socket_client/web_socket_client.dart';

class ViewerWebSocketClient{
  late final WebSocket socket;
  late final Stream<dynamic> _messageHandler;
  late final Stream<ConnectionState> _stateHandler;

  ViewerWebSocketClient(
      String host, int port) {
    String url = 'ws://$host:$port';
    var uri = Uri.parse(url);
    var backoff = const ConstantBackoff(Duration(seconds: 1));
    socket = WebSocket(uri, backoff: backoff);
    _messageHandler = socket.messages;
    _stateHandler = socket.connection;
  }

  Stream<dynamic> get message => _messageHandler;
  Stream<ConnectionState> get state => _stateHandler;

  void send(dynamic message) async{
    socket.send(message);
  }

  Future<void> dispose() async {
    return socket.close();
  }
}