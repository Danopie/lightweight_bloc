import 'package:rxdart/rxdart.dart';

abstract class Bloc<T> {
  BehaviorSubject<T> _modelController;

  Observable<T> get modelStream => _modelController.stream;

  Bloc() {
    _modelController = BehaviorSubject<T>(seedValue: initialModel);
  }

  T get initialModel;

  T get latestModel => _modelController.value;

  void init();

  void update(T newModel) {
    if (!_modelController.isClosed) {
      _modelController.add(newModel);
    }
  }

  void dispose() {
    _modelController.close();
  }
}
