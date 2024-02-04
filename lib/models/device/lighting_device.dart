class LightingDevice {
  final String deviceId;
  final String deviceName;
  final LightingStatus deviceStatus;

  const LightingDevice({
    required this.deviceId,
    required this.deviceName,
    required this.deviceStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'deviceId': this.deviceId,
      'deviceName': this.deviceName,
      'deviceStatus': this.deviceStatus.name,
    };
  }

  Map<String, dynamic> toMapForViewer() {
    return {
      'id':'id',
      'value': this.deviceStatus == LightingStatus.on ? 1 : 0,
      'name': this.deviceName,
      'type':'lighting'
    };
  }

  factory LightingDevice.fromMap(Map<String, dynamic> map) {
    LightingStatus status = LightingStatus.values
            .where((element) => element.name == map['deviceStatus'])
            .firstOrNull ??
        LightingStatus.error;
    return LightingDevice(
      deviceId: map['deviceId'] as String,
      deviceName: map['deviceName'] as String,
      deviceStatus: status,
    );
  }

  LightingDevice copyWith({
    String? deviceId,
    String? deviceName,
    LightingStatus? deviceStatus,
    LightingStatus? status,
  }) {
    return LightingDevice(
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      deviceStatus: deviceStatus ?? this.deviceStatus,
    );
  }
}

enum LightingStatus {
  on,
  off,
  error;
}
