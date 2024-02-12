enum ActionWithDeviceEnum{
  open_viewer('ready viewer'),

  light_switch_space('/devices/knx_main5_middle0/controls/control5_0_13/on'),
  light_switch_space_fb('/devices/knx_main5_middle1/controls/control5_1_13'),
  light_switch_space_dim('/devices/knx_main5_middle2/controls/control5_2_13/on'),
  light_switch_space_dim_fb('/devices/knx_main5_middle3/controls/control5_3_13'),
  light_switch_cabinet('/devices/knx_main5_middle0/controls/control5_0_12/on'),
  light_switch_cabinet_fb('/devices/knx_main5_middle1/controls/control5_1_12'),
  light_switch_two_dim(''),
  light_switch_two_dim_fb(''),
  curtains_switch_space('/devices/knx_main6_middle0/controls/control6_0_5/on'),
  curtains_stop_space('/devices/knx_main6_middle1/controls/control6_1_5/on'),
  curtains_switch_cabinet('/devices/knx_main6_middle0/controls/control6_0_2/on'),
  curtains_stop_cabinet('/devices/knx_main6_middle1/controls/control6_1_2/on'),

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