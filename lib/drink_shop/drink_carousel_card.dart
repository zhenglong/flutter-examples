import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/drink_shop/colors.dart';

class DrinkCarouselCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(110.0, 80.0),
      painter: DrinkCarouselCardPainter(),
    );
  }
}

class DrinkCarouselCardPainter extends CustomPainter {
  final Paint cardPaint;
  final Paint cardLinePaint;
  final Paint cardBackPaint;

  DrinkCarouselCardPainter()
    : cardPaint = Paint(),
      cardBackPaint = Paint(),
      cardLinePaint = Paint() {
    cardPaint.color = DrinkShopColors.carouselCardColor;
    cardPaint.style = PaintingStyle.fill;
    cardLinePaint.color = DrinkShopColors.carouselCardLineColor;
    cardLinePaint.style = PaintingStyle.fill;
    cardBackPaint.color = DrinkShopColors.carouselCardBackColor;
    cardBackPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Path cardBackPath = Path();
    cardBackPath.moveTo(0.8*size.width, 0.0);
    cardBackPath.lineTo(size.width, 0.6*size.height);
    cardBackPath.lineTo(0.2*size.width, 0.6*size.height);
    cardBackPath.close();
    canvas.drawPath(cardBackPath, cardBackPaint);

    var cardPath = Path();
    cardPath.moveTo(0.2*size.width, 0.0);
    cardPath.lineTo(0.0, 0.7*size.height);
    cardPath.lineTo(0.6*size.width, size.height);
    cardPath.lineTo(0.8*size.width, 0.0);
    cardPath.close();
    canvas.drawPath(cardPath, cardPaint);

    canvas.rotate(8 * (pi / 180));
    canvas.save();

    final horizontalPadding = 5.0;
    final verticalPadding = 10.0;
    final lineHeight = 20.0;
    var rrect = RRect.fromLTRBR(
      0.2*size.width+horizontalPadding, 
      verticalPadding, 
      0.7*size.width-horizontalPadding, 
      lineHeight,
      Radius.circular(5.0)
    );
    canvas.drawRRect(rrect, cardLinePaint);
    canvas.rotate(4 * (pi / 180));

    rrect = RRect.fromLTRBR(
      0.2*size.width+horizontalPadding, 
      verticalPadding+lineHeight, 
      0.7*size.width-horizontalPadding, 
      2*verticalPadding+lineHeight, 
      Radius.circular(5.0)
    );
    canvas.drawRRect(rrect, cardLinePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}