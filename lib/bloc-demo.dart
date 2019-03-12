import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CountBloc {
  int _count;
  StreamController<int> _countController;

  CountBloc() {
    _count = 0;
    _countController = StreamController<int>();
  }

  Stream<int> get value => _countController.stream;

  increment() {
    _countController.sink.add(++_count);
  }

  dispose() {
    _countController.close();
  }
}

class BlocProvider extends InheritedWidget {
  final CountBloc bloc = CountBloc();

  BlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static CountBloc of(BuildContext context) => (context.inheritFromWidgetOfExactType(BlocProvider) as BlocProvider).bloc;
}

class DemoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DemoPageState();
  }
}

class DemoPageState extends State<DemoPage> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: DemoPageContainer(),
    );
  }
}

class DemoPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('bloc-demo'),
      ),
      body: DemoContent(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            BlocProvider.of(context).increment();
          },
          child: Icon(Icons.add)
      ),
    );
  }
}

class DemoContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        builder: (context, snapshot) {
          return Text('${snapshot.data}', style: TextStyle(fontSize: 60),);
        },
        stream: BlocProvider.of(context).value,
        initialData: 0,
      ),
    );
  }
}