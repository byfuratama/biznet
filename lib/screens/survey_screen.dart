import 'package:flutter/material.dart';
import '../widgets/numbered_tile.dart';
import './survey_edit_screen.dart';

class SurveyScreen extends StatelessWidget {
  static const routeName = '/survey-screen';
  final Color color = Colors.green;

  SurveyScreen();

  void selectMenu(BuildContext context, Object id) {
    Navigator.of(context).pushNamed(
      SurveyEditScreen.routeName,
      arguments: id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Survey'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => selectMenu(context, ''),
          ),
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return InkWell(
              onTap: () => selectMenu(context, index.toString()),
              child: NumberedTile(
                index + 1,
                ['<Customer>', '<Tanggal Survey>'],
                Chip(
                  label: Text('STATUS'),
                ),
              ),
            );
          },
          itemCount: 15,
        ),
      ),
    );
  }
}
