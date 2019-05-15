import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/drink_shop/colors.dart';
import 'package:flutter_app/drink_shop/drink_switch_menu.dart';
import 'package:flutter_app/drink_shop/icons.dart';

class DrinkShopHeader extends StatelessWidget {
  final StreamController drinkTypeStream;

  DrinkShopHeader(this.drinkTypeStream);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20.0,
        right: 20.0
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
            icon: Icon(
              DrinkShopIcons.menu,
              color: DrinkShopColors.headerIconColor,
              size: 30.0,
            ),
            onPressed: (){},
          ),
          Expanded(
            child: Container(),
          ),
          DrinkSwitchMenu(drinkTypeStream)
        ],
      ),
    );
  }
}