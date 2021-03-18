import 'package:flutter/material.dart';
import 'package:lightweight_bloc/src/bloc.dart';
import 'package:lightweight_bloc/src/bloc_builder.dart';
import 'package:lightweight_bloc/src/bloc_listener.dart';

class BlocConsumer<T extends Bloc<M>, M> extends StatefulWidget {
  final T? bloc;
  final BlocWidgetBuilderFunction<T, M> builder;
  final BlocListenerFunction<T, M>? listener;

  const BlocConsumer(
      {Key? key, required this.builder, this.bloc, this.listener})
      : super(key: key);

  @override
  _BlocConsumerState<T, M> createState() => _BlocConsumerState<T, M>();
}

class _BlocConsumerState<T extends Bloc<M>, M>
    extends State<BlocConsumer<T, M>> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<T, M>(
      bloc: widget.bloc,
      listener: widget.listener,
      child: BlocWidgetBuilder<T, M>(
        bloc: widget.bloc,
        builder: widget.builder,
      ),
    );
  }
}
