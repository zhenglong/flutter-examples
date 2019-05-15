import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/drink_shop/models.dart';

class DrinkSwitchMenu extends StatefulWidget {

  final StreamController<DrinkType> drinkTypeStream;

  DrinkSwitchMenu(this.drinkTypeStream);

  @override
  State<StatefulWidget> createState() {
    return DrinkSwitchMenuState();
  }
}

class DrinkSwitchMenuState extends State<DrinkSwitchMenu> with TickerProviderStateMixin {

  AnimationController controller;
  Animation<double> drinksScaleAnimation;
  Animation<double> drinksTiltAnimation;
  Animation<double> drinksTranslateAnimation;

  static Key frappeKey = Key('frappe');
  static Key glassKey = Key('glass');
  Key active = frappeKey;
  
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200)
    );
    drinksScaleAnimation = Tween<double>(begin: 0.0, end: 40.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn)
      )
    );
    drinksTiltAnimation = Tween<double>(begin: 0.0, end: 40.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn)
      )
    );
    drinksTranslateAnimation = Tween<double>(begin: 0.0, end: 30.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn)
      )
    );
    drinksScaleAnimation.addListener(() {
      setState(() {});
    });
    drinksTiltAnimation.addListener(() {
      setState(() {});
    });
    drinksTranslateAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inactiveTransform = Matrix4.identity()
      ..translate(-10.0 - drinksTranslateAnimation.value, 0.0, 0.0)
      ..scale(drinksScaleAnimation.value, drinksScaleAnimation.value)
      ..rotateZ(-drinksTiltAnimation.value * (pi / 180));

    final activeTransform = Matrix4.identity()
      ..translate(0.0, 10.0 + drinksTranslateAnimation.value, 0.0)
      ..scale(drinksScaleAnimation.value, drinksScaleAnimation.value)
      ..rotateZ(drinksTiltAnimation.value * (pi / 180));

    final glass = Transform(
      key: glassKey,
      transform: active == glassKey ? activeTransform : inactiveTransform,
      origin: Offset(20.0, 20.0),
      child: Image.asset(
        'assets/images/glass.png',
        width: 35.0,
        height: 35.0,
      ),
    );

    final frappe = Transform(
      key: frappeKey,
      transform: active == frappeKey ? activeTransform : inactiveTransform,
      origin: Offset(20.0, 20.0),
      child: Image.asset(
        'assets/images/frappe.png',
        width: 35.0,
        height: 35.0
      ),
    );


    return GestureDetector(
      onTap: () {
        swapDrinks();
      },
      child: Container(
        child: Stack(
          children: active == glassKey ? <Widget>[frappe, glass] : <Widget>[glass, frappe],
        ),
      ),
    );
  }

  void swapDrinks() async {
    await controller.forward();

    widget.drinkTypeStream.add(active == frappeKey ? DrinkType.glass : DrinkType.frappe);

    await controller.reverse();

    setState(() {
      if (active == glassKey) {
        active = frappeKey;
      } else if (active == frappeKey) {
        active = glassKey;
      }
    });
  }
}