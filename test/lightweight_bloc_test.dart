import 'dart:async';

import 'package:lightweight_bloc/src/bloc.dart';
import 'package:test/test.dart';

void main() {
  test("Bloc should emit the initial state", () async {
    final sut = CountBloc();
    expectLater(sut, emitsInOrder([0]));
    sut.dispose();
  });

  test("Bloc should emit the last state when listened to", () async {
    final sut = CountBloc();
    sut.update(1);
    await Future.delayed(Duration.zero);

    expectLater(sut, emitsInOrder([1]));

    await Future.delayed(Duration(seconds: 1));
    sut.dispose();
  });

  test("Bloc should emit the state in orders", () async {
    final sut = CountBloc();

    expectLater(sut, emitsInOrder([0, 1, 2, emitsDone]));

    await Future.delayed(Duration.zero);
    sut.update(1);
    sut.update(2);

    await Future.delayed(Duration(seconds: 1));
    sut.dispose();
  }, timeout: Timeout(Duration(seconds: 5)));

  test("Bloc should emit event correctly when listening another bloc",
      () async {
    final countBloc = CountBloc();
    final sut = FlagBloc(countBloc);

    sut.init();

    expectLater(sut, emitsInOrder([false, true]));

    countBloc.update(1);
    countBloc.update(2);

    await Future.delayed(Duration(seconds: 1));
    sut.dispose();
    countBloc.dispose();
  }, timeout: Timeout(Duration(seconds: 5)));
}

class CountBloc extends Bloc<int> {
  CountBloc() : super(initialState: 0);

  @override
  void init() {}
}

class FlagBloc extends Bloc<bool> {
  final CountBloc countBloc;
  StreamSubscription? _sub;
  FlagBloc(this.countBloc) : super(initialState: false) {
    _sub = countBloc.listen((event) async {
      if (event == 2) {
        update(true);
      }
    });
  }

  @override
  void init() {}

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
