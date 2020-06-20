# lightweight_bloc

A lightweight implementation of the Bloc pattern

## Purpose
This package loosely follows the Bloc pattern with minimized boilerplate code as the top priority.

## Insipiration
lightweight_bloc is heavily inspired by [flutter_bloc](https://pub.dev/packages/flutter_bloc). If you want a highly scalable and featrue-rich bloc package, use it instead.

## Usage

### BlocProvider
Provider a Bloc to all the nodes below it in the widget trees.

```dart
BlocProvider(
    child: AScreen()
    builder: (context) => ABloc()
)
```

Then in the child widgets, you can access ABloc like this
```dart
final aBloc = BlocProvider.of<ABloc>(context);
```
or
```dart
final aBloc = context.bloc<ABloc>();
```

### Bloc
Handles business logic and provides States to observers.
Every bloc should:
* Extend the Bloc class and pass in it’s State class.

```dart
class ABloc extends Bloc<AState>{
}
```

* Provides **initialState**, which is the state that this Bloc starts with in the Bloc constructor.

```dart
AState():super(initialState: AState.loading())
```

* Define event handling functions, usually starts with “on…”,
* Use **state** to access the latest State object up until then.
* Then use **update** to emits a new State. This State should usually be a clone from the previous State, with different State identifier/data.

```dart
void onUserRefreshPage() async {
  if(state.id == AState.DoneLoading){
    update(state.copyWith(id: AState.Loading);
    // Fetch new data
  }
}
```

### State
Data output of a Bloc.
Every state should:
* Have State identifiers.
* Have a **copyWith** function to clone the current State with some new data.

```dart
class AState {
  static const String Loading = "Loading";
  static const String DoneLoading = "DoneLoading";
  
  String id;
  
  AState copyWith({String id}) => AState(
    id: id ?? this.id
  );
}
```

### BlocListener
A flutter widget provides a listener function that is guaranteed to be called only once every time a bloc’s state changes. This should be used to handle one-time effecs in the UI like navigation, showing a dialog, using controllers.

```dart
 return BlocListener<ABloc, AState>(
  child: ...
  listener: (context, bloc, state){
    if(state.id == AState.DoneLoading){
      showSnackBar("New data loaded");
    }
  }
 );
```

### BlocWidgetBuilder
A flutter widget provides a builder function to render the widgets with the associated State.

```dart
 return BlocListener<ABloc, AState>(
  child: ...
  builder: (context, bloc, state){
    if(state.id == AState.DoneLoading){
      return _buildPage(state);
    } else {
      return _buildLoadingIndicator();
    }
  }
 );
```

### BlocConsumer
A flutter widget that combines BlocWidgetBuilder and BlocListener

```dart
 return BlocConsumer<ABloc, AState>(
  child: ...
  builder: (context, bloc, state){
    if(state.id == AState.DoneLoading){
      return _buildPage(state);
    } else {
      return _buildLoadingIndicator();
    }
  },
  listener: (context, bloc, state){
    if(state.id == AState.DoneLoading){
      showSnackBar("New data loaded");
    }
  }
 );
```

## Tips and Tricks

### Nullable
Sometimes with new events, we want to clear some data in the State. So we might do something like `state.copyWith(data: null)`. However, **copyWith** doesn’t understand and thinks we didn’t pass any value to it.

```dart
class AState {
  int data;
  
  // Passing null is useless, copyWith will always get the current data
  AState copyWith({int data}) => AState(
    data: data ?? this.data
  );
}
```

In these cases, we can use **Nullable<T>** to differentiate between passing a null value and not passing any value at all.
  
```dart
class AState {
  int data;
  
  // Passing null is useless, copyWith will always get the current data
  AState copyWith({Nullable<int> data}) => AState(
    data: data != null ? data.value : this.value
  );
}
```

## Plugin
[Dart Data Class](https://plugins.jetbrains.com/plugin/12429-dart-data-class) to generate data class with copyWith function.
