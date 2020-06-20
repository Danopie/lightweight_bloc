import 'dart:async';

import 'package:lightweight_bloc/src/bloc_observer.dart';

abstract class Bloc<T> extends Stream<T> {

  static final _blocObserver = BlocObserver();

  final _stateController = StreamController<T>.broadcast();

  T _state;

  Bloc({T initialState}) {
    _state = initialState ?? this.initialState;
  }

  T get initialState;

  T get state => _state;

  void init();

  void update(T newState) {
    if (!_stateController.isClosed) {
      _blocObserver.invokeCallbacks(this, state, newState);
      _state = newState;
      _stateController.add(newState);
    }
  }

  @override
  StreamSubscription<T> listen(void onData(T event),
      {Function onError, void onDone(), bool cancelOnError}) {
    return _stateStream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  Stream<T> get _stateStream async* {
    yield state;
    yield* _stateController.stream;
  }

  void dispose() {
    _stateController.close();
  }
}
