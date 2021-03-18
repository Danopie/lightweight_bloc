import 'dart:async';

import 'package:lightweight_bloc/src/bloc_observer.dart';

abstract class Bloc<T> extends Stream<T> {
  static final _blocObserver = BlocObserver();

  final StreamController<T?> _stateController = StreamController<T>.broadcast();

  T? _state;

  late List<T?> _previousStates;

  Bloc({T? initialState}) {
    assert(initialState != null || this.initialState != null);

    _state = initialState ?? this.initialState;

    _previousStates = <T>[];
    _previousStates.add(_state);
  }

  T? get initialState => null;

  T? get state => _state;

  void init();

  Future<void> update(T? newState) async {
    if (!_stateController.isClosed) {
      if (_state != newState) {
        _blocObserver.invokeCallbacks(this, state, newState);
        await Future.delayed(Duration.zero);
        _state = newState;
        _stateController.add(newState);
        _previousStates.add(_state);
      }
    }
  }

  @override
  StreamSubscription<T> listen(void onData(T event)?,
      {Function? onError, void onDone()?, bool? cancelOnError}) {
    return _stateStream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  Stream<T> get _stateStream async* {
    yield state!;
    yield* _stateController.stream as Stream<T>;
  }

  void dispose() {
    _stateController.close();
  }

  void undo() {
    _previousStates.removeLast();
    update(_previousStates.last);
  }
}
