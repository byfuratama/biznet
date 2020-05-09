import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../widgets/numbered_tile.dart';
import '../widgets/mini_detail_modal.dart';
import './survey_edit_screen.dart';
import '../providers/survey.dart';

class SurveyScreen extends StatefulWidget {
  static const routeName = '/survey-screen';

  SurveyScreen();

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  @override
  void didChangeDependencies() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Survey>(context).fetchAndSet();
    });
    super.didChangeDependencies();
  }

  void _selectMenu(BuildContext context, Object id) {
    Navigator.of(context).pushNamed(
      SurveyEditScreen.routeName,
      arguments: id,
    );
  }

  void _showBottomModal(BuildContext context, SurveyItem item) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return MiniDetailModal(
            [
              'Customer Name: ${item.customer}',
              'Equipment : ${item.equipment}',
              'Status: ${item.status}',
            ],
            () {
              Navigator.of(context).pop();
              _selectMenu(context, item.id);
            },
            () {
              Provider.of<Survey>(context).deleteItem(item.id).then((_) {
                Navigator.of(context).pop();
              });
            },
          );
        });
  }

  Future<void> _refreshItems(context) async {
    Provider.of<Survey>(context).fetchAndSet();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id-ID', null);
    final surveyItems = Provider.of<Survey>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('List Survey'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _selectMenu(context, ''),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshItems(context),
        child: Container(
          child: ListView.builder(
            itemBuilder: (ctx, index) {
              var survey = surveyItems.items[index];
              return InkWell(
                onTap: () => _showBottomModal(context, survey),
                child: NumberedTile(
                  index + 1,
                  [
                    survey.customer,
                    DateFormat('dd MMMM yyyy', 'ID').format(DateTime.parse(survey.createdAt)),
                  ],
                  Chip(
                    label: Text(survey.status),
                  ),
                ),
              );
            },
            itemCount: surveyItems.items.length,
          ),
        ),
      ),
    );
  }
}
