import 'package:discalculia/login_page.dart';
import 'package:discalculia/main_page.dart';
import 'package:flutter/material.dart';

class Discalculia extends StatefulWidget {
  const Discalculia({super.key});

  @override
  State<Discalculia> createState() {
    return _DiscalculiaState();
  }
}

class _DiscalculiaState extends State<Discalculia> {
  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white),
            child: MainPage(), //mainscreen kudune
          ),
        ),
      );
  }
}
