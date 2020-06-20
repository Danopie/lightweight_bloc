import 'package:flutter/material.dart';
import 'package:lightweight_bloc/src/bloc.dart';
import 'package:provider/provider.dart';

typedef BlocBuilderFunction<T extends Bloc<dynamic>> = T Function(BuildContext);

class BlocProvider<T extends Bloc<dynamic>> extends ValueDelegateWidget
    with SingleChildCloneableWidget {
  final Widget child;
  final BlocBuilderFunction<T> builder;
  final bool autoInit;
  final UpdateShouldNotify<T> updateShouldNotify;

  BlocProvider({
    Key key,
    this.builder,
    this.child,
    this.autoInit = true,
    this.updateShouldNotify,
  }) : super(
          key: key,
          delegate: BuilderStateDelegate<T>(
            (context) {
              final Bloc b = builder(context);
              if (autoInit) {
                b.init();
              }
              return b;
            },
            dispose: (context, bloc) {
              bloc?.dispose();
            },
          ),
        );

  static T of<T extends Bloc<dynamic>>(BuildContext context) {
    try {
      return Provider.of<T>(context, listen: false);
    } catch (_) {
      throw FlutterError(
        """
        BlocProvider.of() called with a context that does not contain a Bloc of type $T.
        The context used was: $context
        """,
      );
    }
  }

  @override
  SingleChildCloneableWidget cloneWithChild(Widget child) {
    return BlocProvider<T>(
      key: key,
      builder: builder,
      child: child,
      autoInit: autoInit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<T>(
      updateShouldNotify: updateShouldNotify,
      child: child,
      value: delegate.value,
    );
  }
}

class MultiBlocProvider extends StatelessWidget {
  final List<BlocProvider> blocProviders;
  final List<BlocProvider> Function(BuildContext context) builder;
  final Widget child;

  const MultiBlocProvider(
      {Key key, this.blocProviders, this.child, this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(blocProviders != null || builder != null);
    return MultiProvider(
      providers: builder != null ? builder(context) : blocProviders,
      child: child,
    );
  }
}

extension BlocProviderExtension on BuildContext {
  T bloc<T extends Bloc>() {
    return BlocProvider.of<T>(this);
  }
}
