import 'dart:async';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:viewer_with_control/models/mqtt/viewer_mqqt_message.dart';
import 'package:viewer_with_control/services/mqtt/viewer_mqtt_client.dart';

class ViewerMqttService {
  final ViewerMqttClient _viewerMqttClient;

  StreamController<MQTTMessage> _streamController = StreamController();
  late StreamSubscription<MQTTMessage> _streamSubscription;

  Stream<MQTTMessage> get stream => _streamController.stream;

  StreamSink<MQTTMessage> get sink => _streamController.sink;

  ViewerMqttService(String host, int port)
      : _viewerMqttClient = ViewerMqttClient(host, port);

  Future<void> init() async {
    _viewerMqttClient.connectionStateCallBack = (state) {
      switch (state) {
        case MqttConnectionState.disconnecting:
        case MqttConnectionState.disconnected:
        case MqttConnectionState.faulted:
          _streamSubscription.cancel();
          break;
        case MqttConnectionState.connecting:
          break;
        case MqttConnectionState.connected:
          _streamSubscription = stream.listen(_onPublishMessage);
          break;
      }
    };
  }

  void _onPublishMessage(MQTTMessage message) {
    _viewerMqttClient.publish(message);
  }

  Future<void> close() async {
    _streamController.close();
    _viewerMqttClient.close();
  }
}
