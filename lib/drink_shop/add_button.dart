import 'package:flutter/material.dart';
import 'package:flutter_app/drink_shop/colors.dart';
import 'package:flutter_app/drink_shop/icons.dart';

class AddButton extends StatefulWidget {
  final VoidCallback onTap;

  AddButton({@required this.onTap});

  @override
  State<StatefulWidget> createState() {
    return _AddButtonState();
  }
}

class _AddButtonState extends State<AddButton> with SingleTickerProviderStateMixin {

  final double radius = 90.0;
  double radiusScale = 1.0;

  AnimationController buttonAnimationController;
  Animation<double> buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    buttonAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150)
    );
    buttonScaleAnimation = new Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: buttonAnimationController,
        curve: Curves.easeIn
      )
    );
    buttonScaleAnimation.addListener(() {
      setState((){});
    });
  }

  @override
  void dispose() {
    buttonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await buttonAnimationController.forward();
        widget.onTap();
        buttonAnimationController.reverse();
      },
      child: Container(
        width: radius * buttonScaleAnimation.value,
        height: radius * buttonScaleAnimation.value,
        decoration: new BoxDecoration(
          color: DrinkShopColors.buttonColor,
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 1.0,
              blurRadius: 3.0,
              offset: Offset(1.0, 2.0)
            )
          ]
        ),
        child: Icon(
          DrinkShopIcons.plus,
          color: Colors.white,
        ),
      ),
    );
  }
}