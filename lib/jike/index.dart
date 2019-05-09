import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/jike/card_widget.dart';
import 'package:flutter_app/jike/eventbus.dart';
import 'package:flutter_app/jike/model/card_entity.dart';
import 'package:flutter_app/jike/model/mock_data_entity.dart';
import 'package:flutter_app/jike/model/toolbar_item_entity.dart';
import 'package:flutter_app/jike/pull_drag_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transparent_image/transparent_image.dart';

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('jike demo'),
      ),
      body: HomePager(),
    );
  }
}

class HomePager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePagerState();
  }
}

class _HomePagerState extends State<HomePager> {

  List<CardEntity> _cardList;
  List<ToolbarItemEntity> _toolbarList;

  @override
  void initState() {
    super.initState();
    _loadJson();
  }

  Future<String> _loadAsset() async {
    return await rootBundle.loadString('assets/mock/jk_daily_cards.json');
  }

  void _loadJson() {
    _loadAsset().then((json) {
      var res = ResponseDataEntity.fromJson(jsonDecode(json));
      setState(() {
        _cardList = res.data.cards.where((card) => card.picUrl != null).toList();
        _toolbarList = res.data.toolbarItems;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: PullDragWidget(
        dragHeight: 100,
        parallaxRatio: 0.4,
        thresholdRatio: 0.3,
        header: _createHeader(),
        child: _createContent(),
      ),
    );
  }

  _onHeaderItemClick(ToolbarItemEntity entity) {
    Fluttertoast.showToast(msg: entity.title);
  }

  Widget _createHeader() {
    Widget header;
    if (_toolbarList == null || _toolbarList.length == 0) {
      header = Text('Loading...');
    } else {
      header = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _toolbarList.map<Widget>((item) {
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _onHeaderItemClick(item);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: item.picUrl,
                      width: 62,
                      height: 62,
                    ),
                  ),
                  Container(
                    height: 6,
                  ),
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff333333)
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      );
    }
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: header,
    );
  }

  Widget _createContent() {
    if (_cardList == null || _cardList.length == 0) {
      return Container(
        child: Text('Loading...'),
        alignment: Alignment.center,
      );
    } else {
      return Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: _createOptMenus(),
            ),
          ),
          CardStackWidget(
            cardList: _cardList,
            offset: 8,
            cardCount: 2,
          )
        ],
      );
    }
  }

  Widget _createOptMenus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _createMenu(Icons.add_shopping_cart, () => Fluttertoast.showToast(msg: 'some text')),
        _createMenu(Icons.more, () => bus.emit('openCard', true)),
      ],
    );
  }

  Widget _createMenu(IconData icon, GestureTapCallback onTap) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: onTap,
          child: Icon(icon),
        ),
      ),
    );
  }
}