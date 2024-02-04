class CurtainsDevice {
  final String deviceId;
  final int value;
  final String deviceName;
  final CurtainsStatus deviceStatus;
  final CurtainsAction deviceAction;

  const CurtainsDevice({
    required this.deviceId,
    required this.value,
    required this.deviceName,
    required this.deviceStatus,
    required this.deviceAction,
  });

  Map<String, dynamic> toMap() {
    return {
      'deviceId': this.deviceId,
      'value': this.value,
      'deviceName': this.deviceName,
      'deviceStatus': this.deviceStatus.name,
      'deviceAction': this.deviceAction.name,
    };
  }

  Map<String, dynamic> toMapForViewer() {
    return {
      'id':'id',
      'value': this.value,
      'name': this.deviceName,
      'type':'curtains'
    };
  }

  @override
  String toString() {
    return 'CurtainsDevice{deviceId: $deviceId, value: $value, deviceName: $deviceName, deviceStatus: $deviceStatus, deviceAction: $deviceAction}';
  }

  factory CurtainsDevice.fromMap(Map<String, dynamic> map) {
    CurtainsStatus status = CurtainsStatus.values
            .where((element) => element.name == map['deviceStatus'])
            .firstOrNull ??
        CurtainsStatus.error;
    CurtainsAction action = CurtainsAction.values
            .where((element) => element.name == map['deviceAction'])
            .firstOrNull ??
        CurtainsAction.error;

    return CurtainsDevice(
      deviceId: map['deviceId'] as String,
      value: map['value'] as int,
      deviceName: map['deviceName'] as String,
      deviceStatus: status,
      deviceAction: action,
    );
  }

  CurtainsDevice copyWith({
    String? deviceId,
    int? value,
    String? deviceName,
    CurtainsStatus? deviceStatus,
    CurtainsAction? deviceAction,
  }) {
    return CurtainsDevice(
      deviceId: deviceId ?? this.deviceId,
      value: value ?? this.value,
      deviceName: deviceName ?? this.deviceName,
      deviceStatus: deviceStatus ?? this.deviceStatus,
      deviceAction: deviceAction ?? this.deviceAction,
    );
  }
}

enum CurtainsAction { open, close, forward, backward, error }

enum CurtainsStatus { slightly_open, opened, closed, error, undef }
