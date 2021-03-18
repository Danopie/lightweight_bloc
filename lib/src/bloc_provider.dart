import 'package:flutter/material.dart';
import 'package:lightweight_bloc/src/bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

typedef BlocBuilderFunction<T extends Bloc<dynamic>> = T Function(BuildContext);

class BlocProvider<T extends Bloc<dynamic>> extends SingleChildStatefulWidget {
  final Widget? child;
  final BlocBuilderFunction<T>? builder;
  final bool autoInit;

  BlocProvider({
    Key? key,
    this.builder,
    this.child,
    this.autoInit = true,
  }) : super(key: key, child: child);

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

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
}

class _BlocProviderState<T extends Bloc<dynamic>>
    extends SingleChildState<BlocProvider<T>> {
  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return InheritedProvider<T>(
      child: child,
      create: (context) {
        final Bloc b = widget.builder!(context);
        if (widget.autoInit) {
          b.init();
        }
        return b as T;
      },
      dispose: (context, bloc) {
        bloc?.dispose();
      },
    );
  }
}

class MultiBlocProvider extends StatelessWidget {
  final List<BlocProvider>? blocProviders;
  final List<BlocProvider> Function(BuildContext context)? builder;
  final Widget? child;

  const MultiBlocProvider(
      {Key? key, this.blocProviders, this.child, this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(blocProviders != null || builder != null);
    return MultiProvider(
      providers: builder != null ? builder!(context) : blocProviders!,
      child: child,
    );
  }
}

extension BlocProviderEx on BuildContext {
  T bloc<T extends Bloc>() {
    return BlocProvider.of<T>(this);
  }
}
