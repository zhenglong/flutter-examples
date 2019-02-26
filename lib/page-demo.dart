import 'package:flutter/material.dart';

class PageDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new PageDemoState();
}

class PageDemoState extends State<PageDemo> {
  final PageController _pageController = new PageController();
  double _currentPage = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: LayoutBuilder(
            builder: (context, constraints) => new NotificationListener(
                onNotification: (ScrollNotification note) {
                  setState(() {
                    _currentPage = _pageController.page;
                  });
                },
                child: PageView.custom(
                  physics: const PageScrollPhysics(
                    parent: const BouncingScrollPhysics(),
                  ),
                  controller: _pageController,
                  childrenDelegate: SliverChildBuilderDelegate(
                          (context, index) => new SimplePage(
                          '$index',
                          parallaxOffset: constraints.maxWidth / 2.0 * (index - _currentPage)
                      ),
                      childCount: 10
                  ),
                )
            )
        ),
      ),
    );
  }
}

class SimplePage extends StatelessWidget {
  SimplePage(this.data, {
    Key key,
    this.parallaxOffset = 0.0
  }) : super(key: key);

  final String data;
  final double parallaxOffset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              data,
              style: const TextStyle(fontSize: 60),
            ),
            SizedBox(height: 40.0,),
            Transform(
              transform: Matrix4.translationValues(parallaxOffset, 0.0, 0.0),
              child: const Text('some text')
            )
          ],
        )
      ),
    );
  }
}