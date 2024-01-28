part of 'viewer_page_cubit.dart';

class ViewerPageState {
  final ViewerPageStatus status;

  ViewerPageState({required this.status});
}

enum ViewerPageStatus{
  loading,
  loaded,
  closed,
  error,
}
