import 'package:lightweight_bloc/lightweight_bloc.dart';
import 'package:lightweight_bloc_example/main_state.dart';

class MainBloc extends Bloc<MainState> {
  @override
  void init() {}

  @override
  MainState get initialState =>
      MainState().copyWith(state: MainState.STATE_LOADING, count: 0);

  void incrementCounter() {
    update(MainState()
        .copyWith(state: MainState.STATE_OK, count: (state.count) + 1));
  }
}
