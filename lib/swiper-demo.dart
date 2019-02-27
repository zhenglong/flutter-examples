// 代码来源：https://zhuanlan.zhihu.com/p/41565186
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

typedef Widget ItemBuilder(int position);

typedef Widget IndicatorBuilder(int position, int counmt);

typedef void OnClick(int position, BannerWithEval bannerWithEval);

class BannerWithEval {
  BannerWithEval(this.bannerUrl);

  String bannerUrl;
}

class BannerWidget extends StatefulWidget {

  List<BannerWithEval> data;
  int height, delayTime, duration;
  Curve curve;
  ItemBuilder build;
  IndicatorBuilder indicator;
  OnClick onClick;

  BannerWidget({
    Key key,
    @required this.data,
    @required this.curve,
    this.indicator,
    this.build,
    this.onClick,
    this.height = 160,
    this.delayTime = 4000,
    this.duration = 1000
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new BannerState();
  }
}

class BannerState extends State<BannerWidget> {
  Timer timer;
  PageController controller;
  int position, currentPage;
  List<BannerWithEval> bannerList = [];
  bool isRoll = true;

  @override
  void initState() {
    position = 0;
    currentPage = -1;
    controller = PageController(
      initialPage: getRealCount()
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }

  Widget pageView() {
    return Listener(
      onPointerMove: (event) {
        isRoll = true;
      },
      onPointerDown: (event) {
        isRoll = false;
      },
      onPointerUp: (event) {
        isRoll = true;
      },
      onPointerCancel: (event) {
        isRoll = true;
      },
      child: NotificationListener(
        onNotification: (scrollNotification) {
          if (currentPage == -1) {
            isRoll = true;
          } else if (scrollNotification is ScrollEndNotification || scrollNotification is UserScrollNotification) {
            if (currentPage == 0) {
              setState(() {
                currentPage = getRealCount();
                controller.jumpToPage(currentPage);
              });
            }
            isRoll = true;
          } else {
            isRoll = false;
          }
        },
        child: PageView.custom(
          controller: controller,
          onPageChanged: (index) {
            currentPage = index;
            position = index % getRealCount();
            setState(() {
              // nothing to do
            });
          },
          physics: const PageScrollPhysics(
            parent: const BouncingScrollPhysics()
          ),
          childrenDelegate: SliverChildBuilderDelegate((context, index) {
              int current = index % getRealCount();
              BannerWithEval bannerWithEval = bannerList[current];
              return GestureDetector(
                onTap: () => widget.onClick(current, bannerWithEval),
                child: widget.build != null ? widget.build(current) : BannerItem(
                  url: bannerWithEval.bannerUrl
                )
              );
            },
            childCount: bannerList.length
          ),
        )
      )
    );
  }

  Widget indicator() {
    return widget.indicator == null ? Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 20.0,
        padding: EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: circularPoint(getRealCount()),
        ),
      )
    ) : widget.indicator(position, getRealCount());
  }

  List<Widget> circularPoint(int count) {
    List<Widget> children = [];
    for (var i = 0; i < count; i++) {
      children.add(Container(
        width: 6.0,
        height: 6.0,
        margin: EdgeInsets.only(left: 2.0, top: 0.0, right: 2.0, bottom: 2.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: position == i ? Colors.black38 : Colors.white
        ),
      ));
    }
    return children;
  }

  @override
  void dispose() {
    cancelTime();
    controller?.dispose();
    controller = null;
    super.dispose();
  }

  void restTime() {
    if (timer == null) {
      timer = Timer.periodic(Duration(milliseconds: widget.delayTime), (timer) {
        if (isRoll) {
          if (currentPage == -1) {
            currentPage = 0;
            controller.jumpToPage(currentPage);
            return;
          }
          currentPage++;
          controller.nextPage(duration: Duration(milliseconds: widget.duration), curve: widget.curve);
        }
      });
    }
  }

  void cancelTime() {
    timer?.cancel();
    timer = null;
  }

  void restData() {
    for (int i = 0; i < 2; i++) {
      bannerList.addAll(widget.data);
    }
  }

  int getRealCount() => widget.data.length;


}

class BannerItem extends StatefulWidget {
  String url;
  BannerItem({
    Key key,
    @required this.url
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ItemState();
  }
}

class ItemState extends State<BannerItem> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: (context, url) {
        return Container(
          height: 160.0,
          width: double.infinity,
          color: Colors.black38,
          child: Center(
            widthFactor: 2.0,
            heightFactor: 2.0,
          ),
        );
      },
      imageUrl: widget.url,
      fit: BoxFit.cover
    );
  }
}