import 'dart:async';
import 'dart:convert';

import 'package:viewer_with_control/models/action_with_device.dart';
import 'package:viewer_with_control/models/device/curtains_device.dart';
import 'package:viewer_with_control/models/device/lighting_device.dart';
import 'package:viewer_with_control/models/viewer_mqqt_message.dart';
import 'package:viewer_with_control/models/ws/ws_message.dart';
import 'package:viewer_with_control/services/mqtt/viewer_mqtt_service.dart';
import 'package:viewer_with_control/services/ws/viewer_web_socket_service.dart';
import 'package:viewer_with_control/utils/dart_define.dart';

class ViewerDeviceControlRepository {
  ViewerMqttService? _mqttService;
  ViewerWebSocketService? _webSocketService;

  ViewerDeviceControlRepository();

  bool isRemote = false;

  void stop() {
    _webSocketService?.close();
    if (isRemote) {
      _mqttService?.close();
    }
  }

  Future<void> switchRemoteControl(bool isRemote) async {
    try {
      this.isRemote = isRemote;
      if (isRemote) {
        if (_mqttService == null) {
          _initMQTTService();
        }
        _mqttService?.init();
      } else {
        _mqttService?.close();
      }
    } catch (e) {
      print(e);
    }
  }

  void handleViewerMessageForMqtt(ActionMessage incoming) async {
    print('handleViewerMessage::Incoming message: $incoming');
    if (incoming.action == ActionWithDeviceEnum.open_viewer) {
      if (incoming.value == '1') {
        String host = wsHost;
        int port = int.parse(wsPort);
        try {
          _webSocketService = ViewerWebSocketService(host, port);
          _webSocketService?.event.listen(_handleOpcMessage);
        } catch (e) {
          print(e);
        }
      } else {
        _webSocketService?.close();
        if (isRemote) {
          _mqttService?.close();
        }
      }
    }
  }

  void _handleOpcMessage(OpcMessage opcMessage) {
    String body = opcMessage.body;
    switch (opcMessage.messageType) {
      case MessageType.curtains_sc:
        CurtainsDevice curtainsDevice =
            CurtainsDevice.fromMap(jsonDecode(body));
        _handleCurtainsAction(curtainsDevice);
        break;
      case MessageType.lighting_sc:
        LightingDevice lightingDevice =
            LightingDevice.fromMap(jsonDecode(body));
        _handleLightingAction(lightingDevice);
        break;
      default:
        break;
      // TODO: Handle this case.
    }
  }

  void _handleCurtainsAction(CurtainsDevice curtainsDevice) {
    CurtainsDevice update = curtainsDevice.copyWith(
        value: curtainsDevice.deviceStatus == CurtainsStatus.closed ? 0 : 1);
    _viewerStreamSink.add(update.toMapForViewer());
  }

  void _handleLightingAction(LightingDevice lightingDevice) {
    LightingDevice update = lightingDevice.copyWith(
        status: lightingDevice.deviceStatus == LightingStatus.on ?  LightingStatus.off : LightingStatus.on);
    _viewerStreamSink.add(update.toMapForViewer());
  }

  Future<void> _initMQTTService() async {
    String host = mqttHost;
    int port = int.parse(mqttPort);
    _mqttService = ViewerMqttService(host, port);
  }

  void downCurtainsSpace() async {
    if (isRemote) {
      ActionMessage message = ActionMessage(
          action: ActionWithDeviceEnum.curtains_switch_space, value: "0");
      print('MQTT:downCurtainsOne::create message: $message');
      _mqttService?.sink.add(message);
    }
    CurtainsDevice curtainsDevice = CurtainsDevice(
      deviceId: 'curtains2',
      value: 0,
      deviceName: 'curtains2',
      deviceStatus: CurtainsStatus.opened,
      deviceAction: CurtainsAction.close,
    );
    OpcMessage opcMessage = OpcMessage(
        messageType: MessageType.curtains_cs,
        body: jsonEncode(curtainsDevice.toMap()));
    print('WS:downCurtainsOne::create message: $opcMessage');
    _webSocketService?.sink.add(opcMessage);
    _viewerStreamSink.add(curtainsDevice.toMapForViewer());
  }

  void upCurtainsSpace() async {
    if (isRemote) {
      ActionMessage message = ActionMessage(
          action: ActionWithDeviceEnum.curtains_switch_space, value: "1");
      print('MQTT:upCurtainsOne::create message: $message');
      _mqttService?.sink.add(message);
    }
    CurtainsDevice curtainsDevice = CurtainsDevice(
      deviceId: 'curtains2',
      value: 1,
      deviceName: 'curtains2',
      deviceStatus: CurtainsStatus.closed,
      deviceAction: CurtainsAction.open,
    );
    OpcMessage opcMessage = OpcMessage(
        messageType: MessageType.curtains_cs,
        body: jsonEncode(curtainsDevice.toMap()));
    print('WS:upCurtainsOne::create message: $opcMessage');
    _webSocketService?.sink.add(opcMessage);
    _viewerStreamSink.add(curtainsDevice.toMapForViewer());
  }

  void switchLightSpace(bool state) async {
    String value = state ? '1' : '0';

    if (isRemote) {
      ActionMessage message = ActionMessage(
          action: ActionWithDeviceEnum.light_switch_space, value: value);
      print('MQTT:switchLightOne::create message: $message');
      _mqttService?.sink.add(message);
    }
    LightingDevice lightingDevice = LightingDevice(
      deviceId: 'led1',
      deviceName: 'led1',
      deviceStatus: state ? LightingStatus.on : LightingStatus.off,
    );
    OpcMessage opcMessage = OpcMessage(
        messageType: MessageType.lighting_cs,
        body: jsonEncode(lightingDevice.toMap()));
    print('WS:switchLightOne::create message: $opcMessage');
    _webSocketService?.sink.add(opcMessage);
    _viewerStreamSink.add(lightingDevice.toMapForViewer());
  }

  void downCurtainsCabinet() async {
    if (isRemote) {
      ActionMessage message = ActionMessage(
          action: ActionWithDeviceEnum.curtains_switch_cabinet, value: "0");
      print('MQTT:downCurtainsTwo::create message: $message');
      _mqttService?.sink.add(message);
    }
    CurtainsDevice curtainsDevice = CurtainsDevice(
      deviceId: 'curtains1',
      value: 0,
      deviceName: 'curtains1',
      deviceStatus: CurtainsStatus.opened,
      deviceAction: CurtainsAction.close,
    );
    OpcMessage opcMessage = OpcMessage(
        messageType: MessageType.curtains_cs,
        body: jsonEncode(curtainsDevice.toMap()));
    print('WS:downCurtainsTwo::create message: $opcMessage');
    _webSocketService?.sink.add(opcMessage);
    _viewerStreamSink.add(curtainsDevice.toMapForViewer());
  }

  void upCurtainsCabinet() async {
    if (isRemote) {
      ActionMessage message = ActionMessage(
          action: ActionWithDeviceEnum.curtains_switch_cabinet, value: "1");
      print('MQTT:upCurtainsTwo::create message: $message');
      _mqttService?.sink.add(message);
    }
    CurtainsDevice curtainsDevice = CurtainsDevice(
      deviceId: 'curtains1',
      value: 1,
      deviceName: 'curtains1',
      deviceStatus: CurtainsStatus.closed,
      deviceAction: CurtainsAction.open,
    );
    OpcMessage opcMessage = OpcMessage(
        messageType: MessageType.curtains_cs,
        body: jsonEncode(curtainsDevice.toMap()));
    print('WS:upCurtainsTwo::create message: $opcMessage');
    _webSocketService?.sink.add(opcMessage);
    _viewerStreamSink.add(curtainsDevice.toMapForViewer());
  }

  void switchLightCabinet(bool state) async {
    if (isRemote) {
      String value = state ? '1' : '0';
      ActionMessage message = ActionMessage(
          action: ActionWithDeviceEnum.light_switch_cabinet, value: value);
      print('MQTT:switchLightTwo::create message: $message');
      _mqttService?.sink.add(message);
    }
    LightingDevice lightingDevice = LightingDevice(
      deviceId: 'led2',
      deviceName: 'led2',
      deviceStatus: state ? LightingStatus.on : LightingStatus.off,
    );
    OpcMessage opcMessage = OpcMessage(
        messageType: MessageType.lighting_cs,
        body: jsonEncode(lightingDevice.toMap()));
    print('WS:switchLightOne::create message: $opcMessage');
    _webSocketService?.sink.add(opcMessage);
    _viewerStreamSink.add(lightingDevice.toMapForViewer());
  }

  void setWSMessageSink(StreamSink<Map<String, dynamic>> sink) {
    _viewerStreamSink = sink;
  }

  late StreamSink<Map<String, dynamic>> _viewerStreamSink;
}
