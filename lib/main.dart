import 'package:flutter/material.dart';
import 'package:brand/WelcomePage.dart';

import 'WelcomePage.dart';


void main() {
  runApp(brand());
}

class brand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Final Project',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WelcomePage(),
    );
  }
}

