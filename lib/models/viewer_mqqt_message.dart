import 'package:viewer_with_control/models/action_with_device.dart';

class ActionMessage {
  final ActionWithDeviceEnum action;
  final String value;

  const ActionMessage({
    required this.action,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'action': this.action.name,
      'value': this.value,
    };
  }

  factory ActionMessage.fromMap(Map<String, dynamic> map) {
    return ActionMessage(
      action: map['action'] as ActionWithDeviceEnum,
      value: map['value'] as String,
    );
  }

  @override
  String toString() {
    return 'ActionMessage{action: $action, value: $value}';
  }
}
