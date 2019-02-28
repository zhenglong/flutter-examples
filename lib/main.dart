import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import './swiper-demo.dart';

void main() => runApp(MyApp());

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light
);
final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400]
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: defaultTargetPlatform == TargetPlatform.iOS ? kIOSTheme : kDefaultTheme,
        home: BannerWidget(data: <BannerWithEval>[
          BannerWithEval('https://resu8.hjfile.cn/resu8/2019/02/18/e8ff827ab456bffff480866440df939b.jpg'),
          BannerWithEval('https://resu8.hjfile.cn/resu8/2019/02/19/5affed5bb7d2fd1b311967b3b8d38412.jpg'),
          BannerWithEval('https://resu8.hjfile.cn/resu8/2019/02/19/47e9617284f601e848f525edf8b7146e.jpg'),
          BannerWithEval('https://resu8.hjfile.cn/resu8/2019/02/27/a01407a09977b527a05f98b8743572f9.jpg'),
          BannerWithEval('https://resu8.hjfile.cn/resu8/2019/02/22/9d4359ea9de0a2d39b68600e30f89d0c.jpg'),
        ], curve: Curves.linear, ratio: 196.0 / 640.0
        )
    );
  }
}
