import 'dart:async';
import 'dart:developer';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:viewer_with_control/models/viewer_mqqt_message.dart';
import 'package:viewer_with_control/services/mqtt/viewer_mqtt_client.dart';

class ViewerMqttService {
  final ViewerMqttClient _viewerMqttClient;

  late StreamController<ActionMessage> _streamController;

  Stream<ActionMessage> get stream => _streamController.stream;

  StreamSink<ActionMessage> get sink => _streamController.sink;

  ViewerMqttService(String host, int port)
      : _viewerMqttClient = ViewerMqttClient(host, port);

  Future<void> init() async {
    _viewerMqttClient.connectionStateCallBack = (state) {
      switch (state) {
        case MqttConnectionState.disconnecting:
        case MqttConnectionState.disconnected:
        case MqttConnectionState.faulted:
          _streamController.close();
          break;
        case MqttConnectionState.connecting:
          _streamController = StreamController();
          break;
        case MqttConnectionState.connected:
          stream.listen(_onPublishMessage);
          break;
      }
    };
    _viewerMqttClient.connect();
  }

  void _onPublishMessage(ActionMessage message) {
    log('${message}');
    _viewerMqttClient.publish(message);
  }

  Future<void> close() async {
    _viewerMqttClient.close();
  }
}
