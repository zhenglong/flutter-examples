import 'dart:async';
import 'package:flutter/material.dart';

enum NUMBER_TYPE {
  FIRST,
  SECOND,
  THIRD
}

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NumberManagerWidget(child: MyApp(), updateMs: 1000);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('inherited model demo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Inherited Model Views'),
                InheritedModelView(type: NUMBER_TYPE.FIRST,),
                InheritedModelView(type: NUMBER_TYPE.SECOND,),
                InheritedModelView(type: NUMBER_TYPE.THIRD,),
                SizedBox(height: 25.0,),
                Text('Inherited Widget Views'),
                InheritedWidgetView(type: NUMBER_TYPE.FIRST),
                InheritedWidgetView(type: NUMBER_TYPE.SECOND),
                InheritedWidgetView(type: NUMBER_TYPE.THIRD),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class NumberModel extends InheritedModel<NUMBER_TYPE> {
  final int firstValue, secondValue, thirdValue;

  NumberModel({
    @required this.firstValue,
    @required this.secondValue,
    @required this.thirdValue,
    @required Widget child
  }) : super(child: child);

  @override
  bool updateShouldNotify(NumberModel oldWidget) {
    return firstValue != oldWidget.firstValue ||
        secondValue != oldWidget.secondValue ||
        thirdValue != oldWidget.thirdValue;
  }

  @override
  bool updateShouldNotifyDependent(NumberModel oldWidget, Set<NUMBER_TYPE> dependencies) {
    return ((dependencies.contains(NUMBER_TYPE.FIRST) && oldWidget.firstValue != firstValue) ||
        (dependencies.contains(NUMBER_TYPE.SECOND) && oldWidget.secondValue != secondValue) ||
        (dependencies.contains(NUMBER_TYPE.THIRD) && oldWidget.thirdValue != thirdValue));
  }

  static NumberModel of(BuildContext context, {NUMBER_TYPE aspect}) {
    return InheritedModel.inheritFrom<NumberModel>(context, aspect: aspect);
  }

  Widget getLabeledText(NUMBER_TYPE type) {
    switch (type) {
      case NUMBER_TYPE.FIRST:
        return Text('First Number: $firstValue');
      case NUMBER_TYPE.SECOND:
        return Text('Second Number: $secondValue');
      case NUMBER_TYPE.THIRD:
        return Text('Third Number: $thirdValue');
    }
    return Text('Unkown Number Type $type');
  }
}

class NumberManagerWidget extends StatefulWidget {
  final int updateMs;
  final Widget child;

  NumberManagerWidget({Key key, @required this.child, @required this.updateMs})
      : assert(child != null),
        assert(updateMs > 0),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NumberManagerWidgetState();
  }
}

class NumberManagerWidgetState extends State<NumberManagerWidget> {
  int firstTick, secondTick, thirdTick;
  Timer updateTimer;

  @override
  void initState() {
    super.initState();
    firstTick = secondTick = thirdTick = 0;
    resetTimer();
  }

  @override
  Widget build(BuildContext context) {
    return NumberModel(
      firstValue: firstTick,
      secondValue: secondTick,
      thirdValue: thirdTick,
      child: widget.child,
    );
  }

  @override
  void didUpdateWidget(NumberManagerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    resetTimer();
  }

  @override
  void dispose() {
    updateTimer?.cancel();
    super.dispose();
  }

  void resetTimer() {
    updateTimer?.cancel();
    updateTimer = Timer.periodic(
        Duration(milliseconds: widget.updateMs),
            (Timer t) {
          setState(() {
            firstTick++;
            if (firstTick % 2 == 0) {
              secondTick++;
              if (secondTick % 2 == 0) {
                thirdTick++;
              }
            }
          });
        }
    );
  }
}

class _ColorRegistry {
  final List<Color> colors = [
    Colors.pink,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.lightGreen,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple
  ];

  int _idx = 0;

  Color nextColor() {
    if (_idx >= colors.length) {
      _idx = 0;
    }
    return colors[_idx++];
  }
}

class _ColoredBox extends StatelessWidget {
  final Color color;
  final Widget child;

  const _ColoredBox({Key key, this.color, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: EdgeInsets.all(20),
      child: child,
    );
  }
}

class InheritedModelView extends StatelessWidget {
  final _ColorRegistry r = _ColorRegistry();

  final NUMBER_TYPE type;

  InheritedModelView({Key key, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NumberModel model = NumberModel.of(context, aspect: type);
    return _ColoredBox(
      color: r.nextColor(),
      child: model.getLabeledText(type),
    );
  }
}

class InheritedWidgetView extends StatelessWidget {
  final _ColorRegistry r = _ColorRegistry();

  final NUMBER_TYPE type;

  InheritedWidgetView({Key key, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NumberModel view = NumberModel.of(context);
    return _ColoredBox(
      color: r.nextColor(),
      child: view.getLabeledText(type),
    );
  }
}