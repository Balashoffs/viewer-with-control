import 'dart:async';

import 'package:viewer_with_control/models/action_with_device.dart';
import 'package:viewer_with_control/models/viewer_mqqt_message.dart';
import 'package:viewer_with_control/services/mqtt/viewer_mqtt_service.dart';
import 'package:viewer_with_control/services/ws/viewer_web_socket_service.dart';
import 'package:viewer_with_control/utils/dart_define.dart';

class ViewerDeviceControlRepository {
  late final ViewerMqttService _mqttService;
  late final ViewerWebSocketService _webSocketService;

  ViewerDeviceControlRepository();

  bool isRemote = false;

  void stop() {
    _webSocketService.close();
    if (isRemote) {
      _mqttService.close();
    }
  }

  void switchRemoteControl(bool isRemote) async {
    this.isRemote = isRemote;
    if (isRemote) {
      _initMQTTService();
    } else {
      _mqttService.close();
    }
  }

  void handleViewerMessage(ActionMessage incoming) async {
    if (incoming.action == ActionWithDeviceEnum.open_viewer) {
      if (incoming.value == '1') {
        String host = wsHost;
        int port = int.parse(wsPort);
        _webSocketService = ViewerWebSocketService(host, port);
        _webSocketService.stream.listen((_handleWsMessage));
        _webSocketService.init();
      } else {
        _webSocketService.close();
        if (isRemote) {
          _mqttService.close();
        }
      }
    }
  }

  void _handleWsMessage(ActionMessage actionMessage) {
    print(actionMessage);
  }

  void _initMQTTService() {
    String host = mqttHost;
    int port = int.parse(mqttPort);
    _mqttService = ViewerMqttService(host, port);
    _mqttService.init();
  }

  void downCurtainsOne() {
    ActionMessage message = ActionMessage(
        action: ActionWithDeviceEnum.curtains_switch_one, value: "0");
    if (isRemote) {
      _mqttService.sink.add(message);
    }
    _webSocketService.sink.add(message);
    _wsStreamSink.add(message);
  }

  void upCurtainsOne() {
    ActionMessage message = ActionMessage(
        action: ActionWithDeviceEnum.curtains_switch_one, value: "1");
    if (isRemote) {
      _mqttService.sink.add(message);
    }
    _webSocketService.sink.add(message);
    _wsStreamSink.add(message);
  }

  void switchLightOne(bool state) {
    String value = state ? '1' : '0';
    ActionMessage message = ActionMessage(
        action: ActionWithDeviceEnum.light_switch_one, value: value);
    if (isRemote) {
      _mqttService.sink.add(message);
    }
    _webSocketService.sink.add(message);
    _wsStreamSink.add(message);
  }

  void downCurtainsTwo() {
    ActionMessage message = ActionMessage(
        action: ActionWithDeviceEnum.curtains_switch_two, value: "0");
    if (isRemote) {
      _mqttService.sink.add(message);
    }
    _webSocketService.sink.add(message);
    _wsStreamSink.add(message);
  }

  void upCurtainsTwo() {
    ActionMessage message = ActionMessage(
        action: ActionWithDeviceEnum.curtains_switch_two, value: "1");
    if (isRemote) {
      _mqttService.sink.add(message);
    }
    _webSocketService.sink.add(message);
    _wsStreamSink.add(message);
  }

  void switchLightTwo(bool state) {
    String value = state ? '1' : '0';
    ActionMessage message = ActionMessage(
        action: ActionWithDeviceEnum.light_switch_one, value: value);
    if (isRemote) {
      _mqttService.sink.add(message);
    }
    _webSocketService.sink.add(message);
    _wsStreamSink.add(message);
  }

  void setWSMessageSink(StreamSink<ActionMessage> sink) {
    _wsStreamSink = sink;
  }

  late StreamSink<ActionMessage> _wsStreamSink;
}
