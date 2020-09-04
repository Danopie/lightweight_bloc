import 'dart:async';

import 'package:lightweight_bloc/src/bloc_observer.dart';
import 'package:rxdart/rxdart.dart';

abstract class Bloc<T> extends Stream<T> {
  static final _blocObserver = BlocObserver();

  BehaviorSubject<T> _stateController;

  T _state;

  List<T> _previousStates;

  Bloc({T initialState}) {
    assert(initialState != null || this.initialState != null);

    _state = initialState ?? this.initialState;
    _stateController = BehaviorSubject<T>(seedValue: _state);

    _previousStates = List<T>();
    _previousStates.add(_state);
  }

  T get initialState => null;

  T get state => _state;

  void init();

  void update(T newState) {
    if (!_stateController.isClosed) {
      if (_state != newState) {
        _blocObserver.invokeCallbacks(this, state, newState);
        _state = newState;
        _stateController.add(newState);
        _previousStates.add(_state);
      }
    }
  }

  @override
  StreamSubscription<T> listen(void onData(T event),
      {Function onError, void onDone(), bool cancelOnError}) {
    return _stateController.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  void dispose() {
    _stateController.close();
  }

  void undo() {
    _previousStates.removeLast();
    update(_previousStates.last);
  }
}
