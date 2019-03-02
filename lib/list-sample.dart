import 'package:flutter/material.dart';

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyListPage();
  }
}


class MyListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyListState();
  }
}

class MyListState extends State<MyListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('listview demo'),),
      body: PageView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
//            width: MediaQuery.of(context).size.width,
//            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: Colors.red),
            child: Center(
                child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 50),)
            ),
          ),
          Container(
//            width: MediaQuery.of(context).size.width,
//            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: Colors.green),
            child: Center(
                child: const Text('2', style: TextStyle(color: Colors.white, fontSize: 50),)
            ),
          ),
          Container(
//            width: MediaQuery.of(context).size.width,
//            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: Colors.red),
            child: Center(
                child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 50),)
            ),
          ),
        ],
      ),
    );
  }
}