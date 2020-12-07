import 'package:flutter/material.dart';
import 'package:voteit/app.dart';
import 'package:voteit/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: VoteItApp());
  }
}
