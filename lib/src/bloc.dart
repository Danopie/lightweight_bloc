import 'package:lightweight_bloc/lightweight_bloc.dart';
import 'package:rxdart/rxdart.dart';

abstract class Bloc<T> {
  static final _blocObserver = BlocObserver();

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
      _blocObserver.invokeCallbacks(this, latestState, newState);
      _stateController.add(newState);
    }
  }

  void dispose() {
    _stateController.close();
  }
}
