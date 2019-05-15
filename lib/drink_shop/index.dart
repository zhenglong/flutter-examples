import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/drink_shop/colors.dart';
import 'package:flutter_app/drink_shop/drink_selection_panel.dart';
import 'package:flutter_app/drink_shop/header.dart';
import 'package:flutter_app/drink_shop/models.dart';

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drink Shop')
      ),
      body: DrinkShopHome(),
    );
  }
}

class DrinkShopHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DrinkShopHomeState();
  }
}

class DrinkShopHomeState extends State<DrinkShopHome> {
  StreamController<DrinkType> drinkTypesStream;

  @override
  void initState() {
    super.initState();
    drinkTypesStream = StreamController<DrinkType>();
  }

  @override
  void dispose() {
    drinkTypesStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final panelSize = Size(screenWidth, screenHeight * 0.6);
    return Scaffold(
      body: Container(
        color: DrinkShopColors.backgroundColor,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: Stack(
          children: <Widget>[
            DrinkSelectionPanel(drinkTypesStream, panelSize),
            DrinkShopHeader(drinkTypesStream),
            _buildOrderItems()
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItems() {
    return Align(
      alignment: Alignment(0.0, 0.8),
      child: Text(
        'Your order will appear here',
        style: TextStyle(
          color: DrinkShopColors.backgroundAccentColor,
          fontSize: 16,
          fontWeight: FontWeight.bold
        )
      ),
    );
  }
}