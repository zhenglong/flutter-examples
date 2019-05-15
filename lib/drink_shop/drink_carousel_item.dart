
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/drink_shop/models.dart';

class DrinkCarouselItem extends StatefulWidget {
  final Size size;
  final Drink drink;
  final bool active;
  final Function(Drink) onDrinkSelected;

  DrinkCarouselItem({
    this.size,
    this.drink,
    this.active: false,
    this.onDrinkSelected
  });

  @override
  State<StatefulWidget> createState() {
    return DrinkCarouselItemState();
  }
}

class DrinkCarouselItemState extends State<DrinkCarouselItem> with SingleTickerProviderStateMixin {

  AnimationController onTapAnimationController;
  Animation<double> tiltAnimation;
  Animation<double> translateAnimation;

  @override
  void initState() {
    super.initState();

    onTapAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300)
    );
    tiltAnimation = Tween<double>(begin: 0.0, end: 40.0).animate(
      CurvedAnimation(
        parent: onTapAnimationController,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOut)
      )
    );
    translateAnimation = Tween<double>(begin: 0.0, end: 60.0).animate(
      CurvedAnimation(
        parent: onTapAnimationController,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOut)
      )
    );
    tiltAnimation.addListener(() {
      setState(() {});
    });
    translateAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final transform = Matrix4.translationValues(
      -translateAnimation.value + 10.0,
      -translateAnimation.value,
      0.0
    )..rotateZ(-tiltAnimation.value * (pi / 180));
    return GestureDetector(
      onTap: _tapped,
      child: Transform(
        alignment: Alignment.center,
        transform: transform,
        child: SizedBox(
          width: widget.size.width,
          height: widget.size.height,
          child: Image.asset(
            widget.drink.asset,
            fit: BoxFit.cover
          ),
        ),
      ),
    );
  }

  void _tapped() async {
    if (widget.active) {
      await onTapAnimationController.forward();
      await onTapAnimationController.reverse();
      if (widget.onDrinkSelected != null) {
        widget.onDrinkSelected(widget.drink);
      }
    }
  }
}