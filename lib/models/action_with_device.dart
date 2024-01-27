enum ActionWithDeviceEnum{
  light_switch_one('/devices/knx_main5_middle0/controls/control5_0_13/on'),
  light_switch_one_fb('/devices/knx_main5_middle1/controls/control5_1_13'),
  light_switch_one_dim('/devices/knx_main5_middle2/controls/control5_2_13/on'),
  light_switch_one_dim_fb('/devices/knx_main5_middle3/controls/control5_3_13'),
  light_switch_two(''),
  light_switch_two_fb(''),
  light_switch_two_dim(''),
  light_switch_two_dim_fb(''),
  curtains_switch_one('/devices/knx_main6_middle0/controls/control6_0_5/on'),
  curtains_stop_one('/devices/knx_main6_middle1/controls/control6_1_5/on'),
  curtains_switch_two(''),
  curtains_stop_two(''),

  light_test_1('/devices/test_lamp_1/controls/power/on'),
  light_test_1_fb('/devices/test_lamp_1/controls/power_fb'),
  light_test_2('/devices/test_lamp_2/controls/power/on'),
  light_test_2_fb('/devices/test_lamp_2/controls/power_fb'),
  light_test_3('/devices/test_lamp_3/controls/power/on'),
  light_test_3_fb('/devices/test_lamp_3/controls/power_fb'),
  light_test_4('/devices/test_lamp_4/controls/power/on'),
  light_test_4_fb('/devices/test_lamp_4/controls/power_fb');

  final String topic;

  const ActionWithDeviceEnum(this.topic);
}