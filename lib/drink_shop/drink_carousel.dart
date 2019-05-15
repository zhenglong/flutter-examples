import 'package:flutter/material.dart';
import 'package:flutter_app/drink_shop/drink_carousel_card.dart';
import 'package:flutter_app/drink_shop/drink_carousel_item.dart';
import 'package:flutter_app/drink_shop/models.dart';

class DrinkCarousel extends StatefulWidget {
  final double opacity;
  final double drinkSwitchYTranslation;
  final double carouselExpandYTranslation;
  final List<Drink> drinks;

  DrinkCarousel({
    Key key,
    this.drinks,
    this.drinkSwitchYTranslation,
    this.carouselExpandYTranslation,
    this.opacity
  });

  @override
  State<StatefulWidget> createState() {
    return _DrinkCarouselState();
  }
}

class _DrinkCarouselState extends State<DrinkCarousel> {
  @override
  Widget build(BuildContext context) {
    final switchTransform = Matrix4.translationValues(
      0.0,
      (-30.0 - widget.drinkSwitchYTranslation) + widget.carouselExpandYTranslation,
      0.0
    );
    final expandTransform = Matrix4.translationValues(
      0.0,
      (-30.0 + widget.carouselExpandYTranslation),
      0.0
    );
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Transform(
          transform: switchTransform,
          child: new Opacity(
            opacity: widget.opacity,
            child: DrinkCarouselScroller(
              drinks: widget.drinks,
              size: Size(MediaQuery.of(context).size.width, 400.0),
            ),
          ),
        ),
        Transform(
          transform: expandTransform,
          child: Align(
            alignment: Alignment(-0.27, 0.4),
            child: DrinkCarouselCard(),
          ),
        )
      ],
    );
  }
}

class DrinkCarouselScroller extends StatefulWidget {
  final List<Drink> drinks;
  final Size size;
  final int initialIndex;

  DrinkCarouselScroller({
    this.drinks,
    this.size,
    this.initialIndex: 3
  }) : assert(initialIndex < drinks.length);

  @override
  State<StatefulWidget> createState() {
    return _DrinkCarouselScrollerState();
  }
}

class _DrinkCarouselScrollerState extends State<DrinkCarouselScroller> {
  int currentActiveIndex;
  final activeItemSize = const Size(140.0, 200.0);

  @override
  void initState() {
    super.initState();
    currentActiveIndex = widget.initialIndex;
  }

  List<DrinkCarouselItem> _buildChildren() {
    final children = <DrinkCarouselItem>[];
    for (var i = 0; i < widget.drinks.length; i++) {
      final child = DrinkCarouselItem(
        size: activeItemSize,
        drink: widget.drinks[i],
        onDrinkSelected: null,
        active: i == currentActiveIndex
      );
      children.add(child);
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    final children = _buildChildren();
    return GestureDetector(
      child: Flow(
        delegate: DrinkCarouselScrollerDelegate(
          items: children,
          scrollerSize: widget.size,
          activeItemSize: activeItemSize,
          activeIndex: currentActiveIndex
        ),
        children: children,
      ),
    );
  }
}

class DrinkCarouselScrollerDelegate extends FlowDelegate {
  static const int maxDrinksPerPage = 5;
  static const activeScale = 1.0;
  static const nextToActiveScale = 0.6;
  static const outerScale = 0.4;

  final List<DrinkCarouselItem> items;
  final Size scrollerSize;
  final Size activeItemSize;
  final int activeIndex;

  DrinkCarouselScrollerDelegate({
    this.items,
    this.scrollerSize,
    this.activeItemSize,
    this.activeIndex
  });

  @override
  Size getSize(BoxConstraints constraints) {
    return scrollerSize;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    var transform;
    final activeItemXPosition = scrollerSize.width / 2 - (activeItemSize.width / 2);
    var activeIndexTransform = Matrix4.translationValues(activeItemXPosition, 80.0, 0.0);

    for (var i = 0; i < context.childCount; i++) {
      int diff = (i - activeIndex).abs();
      switch (diff) {
        case 0:
          context.paintChild(
            i,
            transform: activeIndexTransform,
            opacity: 1.0
          );
          break;
        case 1:
          {
            var xtransform = i < activeIndex ? -activeItemSize.width * 0.6 : activeItemSize.width;
            transform = Matrix4.copy(activeIndexTransform)
              ..translate(xtransform, (activeItemSize.height *0.6) / 2, 0.0)
              ..scale(0.6);
            context.paintChild(
              i,
              transform: transform,
              opacity: 0.8
            );
          }
          break;
        case 2:
        default:
          {
            var xtransform;
            if (transform == null) {
              xtransform = i < activeIndex ? -activeItemSize.width * 0.6 : activeItemSize.width;
              transform = Matrix4.copy(activeIndexTransform)
                ..translate(xtransform, activeItemSize.height * 0.3, 0.0)
                ..scale(0.6);
            }
            xtransform = i < activeIndex ? (-activeItemSize.width * 0.48) : activeItemSize.width;
            transform = Matrix4.copy(transform)
              ..translate(xtransform, activeItemSize.height*0.24, 0.0)
              ..scale(0.48);
            context.paintChild(
              i,
              transform: transform,
              opacity: 0.6
            );
          }
          break;
      }
    }
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return true;
  }
}