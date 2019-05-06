import 'package:flutter/material.dart';
import 'dart:math';

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('animation-demo'),),
      body: AnimationDemo(),
    );
  }
}

class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    return sin(t * pi * 2);
  }
}

class AnimationDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AnimationDemoState();
  }
}

class AnimationDemoState extends State<AnimationDemo> with SingleTickerProviderStateMixin<AnimationDemo> {

  double _R = 25;
  AnimationController controller;
  Animation<double> animation;
  bool toggled = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 2000), 
      vsync: this
    );
    animation = Tween(begin: 25.0, end: 150.0).animate(CurveTween(curve: Curves.bounceInOut).animate(controller))
      ..addListener(() {
        setState(() {
          _R = animation.value;
        });
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('star animation'),),
      body: CustomPaint(
        painter: AnimationView(context, _R),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await (toggled ? controller.reverse() : controller.forward());
          toggled = !toggled;
        },
        child: Icon(Icons.star),
    ));
  }
}

class AnimationView extends CustomPainter {
  Paint _paint;
  BuildContext context;
  double _R;

  AnimationView(this.context, double r) {
    _paint = new Paint();
    _paint.color = Colors.deepOrange;
    _paint.style = PaintingStyle.fill;
    _R = r;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  List<Point<double>> _starPoints() {
    var radian = pi / 180; // 角度弧度换算
    // 内截圆半径
    var t = (1 + pow(tan(18*radian), 2)) / (3 - pow(tan(18*radian), 2));
    var arr = [
      Point<double>(0, 1), // A
      Point<double>(t*cos(54*radian), t*sin(54*radian)), // DD
      Point<double>(cos(18*radian), sin(18*radian)), // B
      Point<double>(t*cos(18*radian), -t*sin(18*radian)), // EE
      Point<double>(cos(54*radian), -sin(54*radian)), // C
      Point<double>(0, -t), // AA
      Point<double>(-cos(54*radian), -sin(54*radian)), // D
      Point<double>(-t*cos(18*radian), -t*sin(18*radian)), // BB
      Point<double>(-cos(18*radian), sin(18*radian)), // E
      Point<double>(-t*cos(54*radian), t*sin(54*radian)) // CC
    ];

    return arr.asMap().map((index, p) => MapEntry(index, index % 2 == 0 ? Point<double>(p.x * _R, p.y * _R) : Point<double>(p.x * 125, p.y * 125))).values.toList();
  }

  void paint(Canvas canvas, Size size) {
    var path = Path();
    var points = _starPoints();
    var index = 0;
    path.moveTo(points[index].x, points[index].y);
    index++;
    while(index < points.length) {
      path.lineTo(points[index].x, points[index].y);
      index++;
    }
    path.close();
    canvas.translate(160, 320);
    canvas.drawPath(path, _paint);
  }
}