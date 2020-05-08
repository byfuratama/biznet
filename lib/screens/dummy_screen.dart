import 'package:flutter/material.dart';

class DummyScreen extends StatelessWidget {
  static const routeName = '/dummy-screen';
  final Color color;

  DummyScreen(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}