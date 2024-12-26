
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_getx/controllers/countercontroller.dart';

class MyHomePage extends StatelessWidget {
  final CounterController contorller = Get.put(CounterController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: Obx(() {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(contorller.count.toString()),
            ],
          ),
        );
      }),

      floatingActionButton: FloatingActionButton(
        onPressed:contorller.increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
