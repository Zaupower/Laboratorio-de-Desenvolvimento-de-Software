
import 'dart:io';

import 'package:flutter/material.dart';

import 'navigation_bar_controller.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Navigation Bar Demo',
      home: BottomNavigationBarController(),
    );
  }
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}