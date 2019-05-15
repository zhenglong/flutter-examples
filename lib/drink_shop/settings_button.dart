import 'package:flutter/material.dart';
import 'package:flutter_app/drink_shop/colors.dart';
import 'package:flutter_app/drink_shop/icons.dart';

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: DrinkShopColors.buttonAccentColor,
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
        DrinkShopIcons.controls,
        color: Colors.white,
      ),
    );
  }
}