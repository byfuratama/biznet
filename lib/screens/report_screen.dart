import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import './dummy_screen.dart';
import '../widgets/app_header.dart';
import '../screens/survey_report_screen.dart';
import '../screens/maintenance_report_screen.dart';
import '../screens/installation_report_screen.dart';
import '../screens/troubleshoot_report_screen.dart';

class ReportScreen extends StatelessWidget {
  void selectMenu(BuildContext context, String route) {
    Navigator.of(context)
        .pushNamed(
      route,
    )
        .then((result) {
      if (result != null) {
        // removeItem(result);
      }
    });
  }

  final List<Map<String, Object>> menus = [
    {
      'title': 'Survey Report',
      'icon': Icons.assessment,
      'route': SurveyReportScreen.routeName,
    },
    {
      'title': 'Installation Report',
      'icon': Icons.move_to_inbox,
      'route': InstallationReportScreen.routeName,
    },
    {
      'title': 'Troubleshoot Report',
      'icon': Icons.call,
      'route': TroubleshootReportScreen.routeName,
    },
    {
      'title': 'Maintenance Report',
      'icon': Icons.build,
      'route': MaintenanceReportScreen.routeName,
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
                  onTap: () => selectMenu(context, menu['route']),
                  child: ListTile(
                    leading: Icon(
                      menu['icon'],
                      color: Colors.white,
                    ),
                    title: Text(
                      menu['title'],
                      style: theme.textTheme.display1
                          .copyWith(color: Colors.white),
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
    initializeDateFormatting('id-ID', null);
    return Container(
      color: theme.backgroundColor,
      width: double.infinity,
      height: 600,
      child: Column(
        children: <Widget>[
          AppHeader('Work Order Report'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: createMenu(context),
          ),
        ],
      ),
    );
  }
}
