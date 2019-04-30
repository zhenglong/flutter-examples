import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/todoList/blocs.dart';

class StatsCounter extends StatefulWidget {

  final StatsBloc Function() buildBloc;

  StatsCounter({Key key, @required this.buildBloc})
    : super(key: key ?? Key('stats counter'));

  @override
  State<StatefulWidget> createState() {
    return StatsCounterState();
  }
}

class StatsCounterState extends State<StatsCounter> {

  StatsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = widget.buildBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text('completed todos', style: Theme.of(context).textTheme.title,),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: StreamBuilder<int>(
              stream: bloc.numComplete,
              builder: (context, snapshot) => Text(
                '${snapshot.data ?? 0}',
                key: Key('stats num completed'),
                style: Theme.of(context).textTheme.subhead,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text('active todos', style: Theme.of(context).textTheme.title,),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: StreamBuilder<int>(
              stream: bloc.numActive,
              builder: (context, snapshot) {
                return Text('${snapshot.data ?? 0}', key: Key('subhead'), style: Theme.of(context).textTheme.subhead);
              },
            ),
          )
        ],
      ),
    );
  }
}