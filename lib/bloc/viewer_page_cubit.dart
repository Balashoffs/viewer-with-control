import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:viewer_with_control/models/action_with_device.dart';
import 'package:viewer_with_control/models/viewer_mqqt_message.dart';
import 'package:viewer_with_control/repository/viewer_device_control_repository.dart';

part 'viewer_page_state.dart';

class ViewerPageCubit extends Cubit<ViewerPageState> {
  final ViewerDeviceControlRepository _deviceControlRepository;

  ViewerPageCubit(this._deviceControlRepository)
      : _incomingStreamController = StreamController(),
        _outputStreamController = StreamController(),
        super(ViewerPageState(status: ViewerPageStatus.loading));

  final StreamController<ActionMessage> _incomingStreamController;
  final StreamController<ActionMessage> _outputStreamController;

  Stream<ActionMessage> get incomingStream => _incomingStreamController.stream;

  Stream<ActionMessage> get outPutStream => _outputStreamController.stream;

  init() async {
    _incomingStreamController.stream.listen(_handleWSMessage);
    _deviceControlRepository.setWSMessageSink(_incomingStreamController.sink);
  }

  void _handleWSMessage(ActionMessage actionMessage) {
    _incomingStreamController.sink.add(actionMessage);
  }

  void ifcViewerLoaded() {
    ActionMessage actionMessage =
        ActionMessage(action: ActionWithDeviceEnum.open_viewer, value: '1');
    _deviceControlRepository.handleViewerMessage(actionMessage);
    emit(ViewerPageState(status: ViewerPageStatus.loaded));
  }

  void closeIfcViewer() {
    ActionMessage actionMessage =
        ActionMessage(action: ActionWithDeviceEnum.open_viewer, value: '0');
    _deviceControlRepository.handleViewerMessage(actionMessage);
    emit(ViewerPageState(status: ViewerPageStatus.closed));
  }

  @override
  Future<Function> close() async {
    _incomingStreamController.close();
    _outputStreamController.close();
    return super.close;
  }
}
