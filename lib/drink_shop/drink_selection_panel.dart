import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/drink_shop/add_button.dart';
import 'package:flutter_app/drink_shop/colors.dart';
import 'package:flutter_app/drink_shop/drink_carousel.dart';
import 'package:flutter_app/drink_shop/models.dart';
import 'package:flutter_app/drink_shop/settings_button.dart';

class DrinkSelectionPanel extends StatefulWidget {
  final StreamController<DrinkType> drinkTypeStream;
  final Size size;

  DrinkSelectionPanel(this.drinkTypeStream, this.size);

  @override
  State<StatefulWidget> createState() {
    return _DrinkSelectionPanelState();
  }
}

class _DrinkSelectionPanelState extends State<DrinkSelectionPanel> with TickerProviderStateMixin {
  AnimationController expansionAnimationController;
  Animation<double> expandAnimation;
  Animation<double> carouselTranslateAnimation;

  AnimationController drinkTypeAnimationController;
  Animation<double> carouselSwitchTranslateAnimation;
  Animation<double> carouselOpacityAnimation;

  DrinkType currentDrinkType = DrinkType.frappe;

  int currentPage = 0;
  PageController pageController;
  List<Drink> drinks;

  @override
  void initState() {
    super.initState();

    drinks = getDrinks(currentDrinkType);
    currentPage = (drinks.length / 2).round();
    pageController = PageController(initialPage: currentPage, viewportFraction: 0.6);

    expansionAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300)
    );
    expandAnimation = Tween<double>(begin: 80.0, end: 0.0).animate(
      CurvedAnimation(
        parent: expansionAnimationController,
        curve: Curves.easeInOut
      )
    );
    carouselTranslateAnimation = Tween<double>(begin:30.0, end: -50.0).animate(
      CurvedAnimation(
        parent: expansionAnimationController, 
        curve: Curves.easeInOut
      )
    );
    expandAnimation.addListener(() {
      setState(() {});
    });
    carouselTranslateAnimation.addListener(() {
      setState(() {});
    });

    drinkTypeAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250)
    );
    carouselSwitchTranslateAnimation = Tween<double>(begin: 0.0, end: 40.0)
      .animate(CurvedAnimation(
        parent: drinkTypeAnimationController,
        curve: Curves.easeInOut
      ));
    carouselSwitchTranslateAnimation.addListener(() {
      setState(() {});
    });
    carouselOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: drinkTypeAnimationController,
        curve: Curves.easeInOut
      )
    );
    carouselOpacityAnimation.addListener(() {
      setState(() {});
    });

    widget.drinkTypeStream.stream.listen((type) async {
      await drinkTypeAnimationController.forward();
      setState(() {
        currentDrinkType = type;
      });
      await drinkTypeAnimationController.reverse();
    });
  }

  @override
  void dispose() {
    expansionAnimationController.dispose();
    drinkTypeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    drinks = getDrinks(currentDrinkType);

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        ClipOval(
          clipper: _CustomClipOval(
            clipOffset: expandAnimation.value - 110
          ),
          child: SizedBox(
            width: widget.size.width,
            height: widget.size.height,
            child: Container(
              padding: const EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                color: DrinkShopColors.backgroundAccentColor
              ),
              child: DrinkCarousel(
                drinks: drinks,
                drinkSwitchYTranslation: carouselSwitchTranslateAnimation.value,
                carouselExpandYTranslation: carouselTranslateAnimation.value,
                opacity: carouselOpacityAnimation.value,
              ),
            ),
          ),
        ),
        Positioned(
          left: widget.size.width / 6,
          top: widget.size.width - 150 + expandAnimation.value,
          child: SettingsButton(),
        ),
        Positioned(
          right: widget.size.width / 6,
          top: widget.size.width - 170 + expandAnimation.value,
          child: AddButton(
            onTap: () {
              if (expansionAnimationController.status != AnimationStatus.completed) {
                expansionAnimationController.forward();
              } else {
                expansionAnimationController.reverse();
              }
            },
          ),
        )
      ],
    );
  }
}

class _CustomClipOval extends CustomClipper<Rect> {
  final double clipOffset;
  _CustomClipOval({this.clipOffset});

  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
      center: Offset(size.width / 2, clipOffset),
      radius: size.height
    );
  }

  @override
  bool shouldReclip(_CustomClipOval oldClipper) {
    return oldClipper.clipOffset != clipOffset;
  }
}