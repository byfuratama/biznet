import 'package:flutter/material.dart';

class SurveyScreen extends StatelessWidget {
  static const routeName = '/survey-screen';
  final Color color = Colors.green;

  SurveyScreen();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}