import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';

final int _itemCount = 20;

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'demo-page');
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AfterLayoutMixin<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          child: Container(
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                      color: Color(0xFF888888),
                      width: 1,
                    )
                ),
//            color: Color(0xFFFF6600)
              ),
              constraints: BoxConstraints(
                  minHeight: 30,
                  maxHeight: 30
              ),
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  ListView.builder(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
//                itemExtent: 60,
                    itemCount: _itemCount,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              print('$index');
                              var size = this.context.size;
                              print('${size.width} ${size.height}');
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: index != 0 ? 16.0 : 0.0, right: index != (_itemCount - 1) ? 16 : 0),
                              child: Text(
                                'entry ${index % 3 == 0 ? 'long' : ''} $index',
                                softWrap: false,
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  Positioned(
                    bottom: -1,
                    left: 0,
                    child: Container(
                      height: 1,
                      width: 60,
                      color: Color(0xFFFF0000),
                    ),
                  )
                ],
              )
          )
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => new AlertDialog(
            content: new Text('Hello world'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('DISMISS'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ]
        )
    );
  }
}
