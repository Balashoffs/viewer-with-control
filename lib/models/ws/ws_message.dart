class OpcMessage {
  final MessageType messageType;
  final String body;

  const OpcMessage({
    required this.messageType,
    required this.body,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageType': this.messageType.name,
      'body': this.body,
    };
  }

  factory OpcMessage.fromMap(Map<String, dynamic> map) {
    MessageType type = MessageType.values.where((element) => element.name == map['messageType']).firstOrNull ?? MessageType.undef;
    return OpcMessage(
      messageType: type,
      body: map['body'] as String,
    );
  }
}


enum MessageType {
  curtains_cs,
  curtains_sc,
  lighting_cs,
  lighting_sc,

  setup_device_sc,
  setup_device_cs,

  undef
}