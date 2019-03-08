import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import './parse-json.dart';

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
    Widget demoPage = DemoPage();
    return (demoPage is MaterialApp) ? demoPage : MaterialApp(
        title: 'Flutter Demo',
        theme: defaultTargetPlatform == TargetPlatform.iOS ? kIOSTheme : kDefaultTheme,
        home: demoPage
    );
  }
}
