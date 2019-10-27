import 'package:rxdart/rxdart.dart';

abstract class Bloc<T> {
  BehaviorSubject<T> _stateController;

  Observable<T> get stateStream => _stateController.stream;

  Bloc() {
    _stateController = BehaviorSubject<T>(seedValue: initialState);
  }

  T get initialState;

  T get latestState => _stateController.value;

  void init();

  void update(T newState) {
    if (!_stateController.isClosed) {
      _stateController.add(newState);
    }
  }

  void dispose() {
    _stateController.close();
  }
}
