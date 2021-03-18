class MainState {
  final String state;
  static const STATE_LOADING = "LOADING";
  static const STATE_OK = "OK";
  static const STATE_ERROR = "ERROR";

  final int count;

  MainState({this.state, this.count});

  MainState copyWith({
    String state,
    int count,
  }) {
    return MainState(
      state: state ?? this.state,
      count: count ?? this.count,
    );
  }
}
