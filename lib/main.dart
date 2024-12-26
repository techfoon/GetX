import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_getx/views/counter.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

