import 'package:biznet/screens/report_preview_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/app_header.dart';

class ReportScreen extends StatelessWidget {
  void selectMenu(BuildContext context, String type, String method) {
    Navigator.of(context).pushNamed(
      ReportPreviewScreen.routeName,
      arguments: {
        'report_type': type,
        'report_method': method,
      },
    ).then((result) {
      if (result != null) {
        // removeItem(result);
      }
    });
  }

  final List<Map<String, Object>> menus = [
    {
      'title': 'Daily Work Order Report',
      'icon': Icons.assignment,
      'type': 'wo',
      'method': 'daily',
    },
    {
      'title': 'Daily Equipment Report',
      'icon': Icons.build,
      'type': 'eq',
      'method': 'daily',
    },
    {
      'title': 'Monthly Work Order Report',
      'icon': Icons.assignment,
      'type': 'wo',
      'method': 'monthly',
    },
    {
      'title': 'Monthly Equipment Report',
      'icon': Icons.build,
      'type': 'eq',
      'method': 'monthly',
    },
  ];

  Widget createMenu(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: menus
            .map(
              (menu) => Card(
                color: Colors.blueAccent,
                child: InkWell(
                  onTap: () => selectMenu(context, menu['type'], menu['method']),
                  child: ListTile(
                    leading: Icon(
                      menu['icon'],
                      color: Colors.white,
                    ),
                    title: Text(
                      menu['title'],
                      style: theme.textTheme.display1.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.backgroundColor,
      width: double.infinity,
      height: 600,
      child: Column(
        children: <Widget>[
          AppHeader('Reporting'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: createMenu(context),
          ),
        ],
      ),
    );
  }
}
