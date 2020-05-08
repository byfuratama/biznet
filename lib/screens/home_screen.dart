import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../screens/survey_screen.dart';
import '../screens/maintenance_screen.dart';
import '../screens/installation_screen.dart';
import '../screens/troubleshoot_screen.dart';

class HomeScreen extends StatelessWidget {
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
      'title': 'Survey',
      'icon': Icons.assessment,
      'route': SurveyScreen.routeName,
    },
    {
      'title': 'Installation',
      'icon': Icons.move_to_inbox,
      'route': InstallationScreen.routeName,
    },
    {
      'title': 'Troubleshoot',
      'icon': Icons.call,
      'route': TroubleshootScreen.routeName,
    },
    {
      'title': 'Maintenance',
      'icon': Icons.build,
      'route': MaintenanceScreen.routeName,
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
    return Container(
      color: theme.backgroundColor,
      width: double.infinity,
      height: 600,
      child: Column(
        children: <Widget>[
          AppHeader('Work Order'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: createMenu(context),
          ),
        ],
      ),
    );
  }
}
