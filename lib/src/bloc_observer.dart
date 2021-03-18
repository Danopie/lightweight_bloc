import 'package:lightweight_bloc/src/bloc.dart';

typedef OnUpdateCallBack = Function(
    Bloc bloc, Object? oldState, Object? newState);

class BlocObserver {
  static BlocObserver _instance = BlocObserver._();
  factory BlocObserver() => _instance;
  BlocObserver._();

  final _updateCallbacks = Set<OnUpdateCallBack>();

  void invokeCallbacks(Bloc bloc, Object? oldState, Object? newState) {
    _updateCallbacks.forEach((c) {
      c(bloc, oldState, newState);
    });
  }

  void registerCallback(OnUpdateCallBack callback) {
    _updateCallbacks.add(callback);
  }
}
