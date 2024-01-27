import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:viewer_with_control/models/mqtt/viewer_mqqt_message.dart';

class ViewerMqttClient{
  final MqttServerClient _client;
  final MqttClientPayloadBuilder _messageBuilder;
  ViewerMqttClient(String host, int port): _client = MqttServerClient.withPort(host, '', port), _messageBuilder = MqttClientPayloadBuilder();

  late Function(MqttConnectionState connectionState) _callback;

  set connectionStateCallBack(Function(MqttConnectionState) callback) {
    _callback = callback;
  }

  Future<void> connect()async{
    _callback.call(MqttConnectionState.connecting);
    _client.useWebSocket = true;
    /// Note do not set the secure flag if you are using wss, the secure flags is for TCP sockets only.
    /// You can also supply your own websocket protocol list or disable this feature using the websocketProtocols
    /// setter, read the API docs for further details here, the vast majority of brokers will support the client default
    /// list so in most cases you can ignore this.  Mosquito needs the single default setting.
    _client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;

    /// Set logging on if needed, defaults to off
    _client.logging(on: false);

    /// Set the correct MQTT protocol for mosquito
    _client.setProtocolV311();

    /// If you intend to use a keep alive you must set it here otherwise keep alive will be disabled.
    _client.keepAlivePeriod = 20;

    /// Add the unsolicited disconnection callback
    _client.onDisconnected = onDisconnected;

    /// Add the successful connection callback
    _client.onConnected = onConnected;

    /// Add a subscribed callback, there is also an unsubscribed callback if you need it.
    /// You can add these before connection or change them dynamically after connection if
    /// you wish. There is also an onSubscribeFail callback for failed subscriptions, these
    /// can fail either because you have tried to subscribe to an invalid topic or the broker
    /// rejects the subscribe request.
    _client.onSubscribed = onSubscribed;

    /// Set a ping received callback if needed, called whenever a ping response(pong) is received
    /// from the broker.
    _client.pongCallback = pong;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
    /// never send malformed messages.
    try {
      await _client.connect();
    } on NoConnectionException catch (e) {
      _callback.call(MqttConnectionState.faulted);
      print('EXAMPLE::client exception - $e');
      _client.disconnect();
      return;
    } on SocketException catch (e) {
      _callback.call(MqttConnectionState.faulted);
      print('EXAMPLE::socket exception - $e');
      _client.disconnect();
      return;
    }

    /// Check we are connected
    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      _callback.call(MqttConnectionState.connected);
      print('EXAMPLE::Mosquitto client connected');
    } else {
      _callback.call(MqttConnectionState.faulted);
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${_client.connectionStatus}');
      _client.disconnect();
      return;
    }
  }
  

  Future<void> publish(MQTTMessage message)async{
    _messageBuilder.clear();
    _messageBuilder.addString(message.value);
    String topic = message.action.topic;
    _client.publishMessage(topic, MqttQos.atLeastOnce, _messageBuilder.payload!);
    _messageBuilder.clear();
  }

  Future<void> close()async{
    _callback.call(MqttConnectionState.disconnecting);
    _client.disconnect();
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    _callback.call(MqttConnectionState.disconnected);
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
  }

  /// The successful connect callback
  void onConnected() {
    print(
        'EXAMPLE::OnConnected client callback - Client connection was successful');
  }

  /// Pong callback
  void pong() {
    print('EXAMPLE::Ping response client callback invoked');
  }
}