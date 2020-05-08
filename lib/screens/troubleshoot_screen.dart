import 'package:flutter/material.dart';

class TroubleshootScreen extends StatelessWidget {
  static const routeName = '/troubleshoot-screen';
  final Color color = Colors.red;

  TroubleshootScreen();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}