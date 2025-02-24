import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Tak1Couille")),
        body: Center(
          child: Image.network(
            'https://picsum.photos/512/512',

          ),
        ),
      ),
    );
  }
}
