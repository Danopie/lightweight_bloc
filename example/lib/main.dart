import 'package:flutter/material.dart';
import 'package:lightweight_bloc/lightweight_bloc.dart';
import 'package:lightweight_bloc_example/main_bloc.dart';
import 'package:lightweight_bloc_example/main_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        builder: (context) => MainBloc(),
        child: MaterialApp(
          title: 'Lightweight Bloc Exmaple',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(
            title: 'Lightweight Bloc Exmaple',
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MainBloc, MainState>(
      listener: (context, bloc, state) {},
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: BlocWidgetBuilder<MainBloc, MainState>(
          builder: (context, bloc, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '${state.count}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              BlocProvider.of<MainBloc>(context).incrementCounter(),
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
