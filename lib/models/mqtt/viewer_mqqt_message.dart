import 'package:viewer_with_control/models/action_with_device.dart';

class MQTTMessage{
  final ActionWithDeviceEnum action;
  final String value;

  const MQTTMessage({
    required this.action,
    required this.value,
  });
}