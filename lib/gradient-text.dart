import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class DemoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('gradient text'),),
      body: Center(
        child: GradientTextWidget(
          Key('gradient-text'), 
          colors: <Color>[Color(0xFFFF0000), Color(0xFF00FF00), Color(0xFF0000FF)],
        ),
      ),
    );
  }
}
class EditableMapEntry {
  Color key;
  double value;
  EditableMapEntry(this.key, this.value);
}

class GradientTextWidget extends StatefulWidget {

  final List<Color> colors;

  GradientTextWidget(Key key, {this.colors})
    :super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GradientTextWidgetState();
  }
}

class GradientTextWidgetState extends State<GradientTextWidget> 
  with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Shader linearGradient;
  bool toggled = false;
  GlobalKey textKey = GlobalKey(debugLabel: 'textkey');
  List<Color> currentColors;

  _shiftColorsRight() {
    var lastVal = currentColors.removeLast();
    currentColors.insert(0, lastVal);
  }

  List<EditableMapEntry> _generateColorStops({double startPoint = 0}) {
    List<EditableMapEntry> res = [];
    res.add(EditableMapEntry(currentColors.last, 0));
    var colorLength = 1.0 / currentColors.length;
    for (var i = 1; i <= currentColors.length; i++) {
      res.add(EditableMapEntry(currentColors[i - 1], startPoint + ((i - 1) * colorLength)));
    }
    return res;
  }

  @override
  void initState() {
    super.initState();
    currentColors = widget.colors.map((item)=>Color(item.value)).toList();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      setState(() {
        RenderBox textRenderBox = textKey.currentContext.findRenderObject();
        var origin = textRenderBox.localToGlobal(Offset.zero);
        var stops = _generateColorStops();
        linearGradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: stops.map((item) => item.key).toList(),
          stops: stops.map((item) => item.value).toList()
        ).createShader(Rect.fromLTWH(origin.dx, origin.dy, textRenderBox.size.width, textRenderBox.size.height));
      });
      animationController = AnimationController(duration: Duration(seconds: 1), vsync: this);
      Animation animation = Tween(begin: 0.0, end: 1.0 / widget.colors.length).animate(animationController);
      animation..addListener(() {
        setState(() {
          RenderBox textRenderBox = textKey.currentContext.findRenderObject();
          var origin = textRenderBox.localToGlobal(Offset.zero);
          var stops = _generateColorStops(startPoint: animation.value);
          linearGradient = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: stops.map((item) => item.key).toList(),
            stops: stops.map((item) => item.value).toList()
          ).createShader(Rect.fromLTWH(origin.dx, origin.dy, textRenderBox.size.width, textRenderBox.size.height));
        });
      })
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          _shiftColorsRight();
          animationController.reset();
          await animationController.forward();
        }
      });
      animationController.forward();
      });
  }

  @override
  Widget build(BuildContext context) {
    Paint paint = Paint();
    if (linearGradient != null) {
      paint.shader = linearGradient;
    }
    return Text(
      'THIS IS GRADIDIENT TEXT',
      key: textKey,
      style: TextStyle(
        fontSize: 60.0,
        fontWeight: FontWeight.bold,
        foreground: paint
      ),
    );
  }
}