import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollDemoPage extends StatefulWidget {
  @override
  State<ScrollDemoPage> createState() {
    return new ScrollDemoState();
  }
}

class ScrollDemoState extends State<ScrollDemoPage> {

  GlobalKey<State> _key = new GlobalKey();
  bool _isVisible = false;
  int _detectedIndex = 35;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        child: ListView.builder(
          // 检测
          itemBuilder: (buildContext, index) {
            return Padding(
              key: index == _detectedIndex ? _key : null,
              padding: const EdgeInsets.all(8.0),
              child: Text(index == _detectedIndex ? '检测${index}可见' : '$index', textAlign: TextAlign.center,),
            );
          },
          itemCount: 100,
        ),
        onNotification: (scroll) {
          var currentContext = _key.currentContext;
          if (currentContext == null) {
            return false;
          }
          var renderObject = currentContext.findRenderObject();
          var viewport = RenderAbstractViewport.of(renderObject);
          var offsetToRevealBottom = viewport.getOffsetToReveal(renderObject, 1.0);
          var offsetToRevealTop = viewport.getOffsetToReveal(renderObject, 0.0);

          var scrollTop = scroll.metrics.pixels;
          print('${scrollTop} ${offsetToRevealTop.offset} ${offsetToRevealBottom.offset}');
          if ((offsetToRevealBottom.offset <= scrollTop) &&
              (scrollTop <= offsetToRevealTop.offset)) {
            if (!_isVisible) {
              _isVisible = true;
              print('visible');
            }
          } else {
            if (_isVisible) {
              _isVisible = false;
              print('hidden');
            }
          }
        },
      ),
    );
  }
}