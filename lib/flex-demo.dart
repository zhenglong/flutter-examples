import 'package:flutter/material.dart';

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('flex demo'),),
      body: FlexDemo(),
    );
  }
}

class FlexDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const childCount = 5;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Container(
          color: Colors.orangeAccent,
          width: width,
          child: Text(
            'some-thing some-thing some-thing some-thing some-thing somesomw-thing some-thing some-thing  somesomw-thing some-thing some-thing',
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 2,
          )
        ),
        Expanded(
          child: Container(color: Colors.lightBlueAccent, width: width),
        ),
      ],
    );
  }
}