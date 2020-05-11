import 'package:biznet/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_header.dart';
import '../screens/survey_screen.dart';
import '../screens/maintenance_screen.dart';
import '../screens/installation_screen.dart';
import '../screens/troubleshoot_screen.dart';
import '../screens/pegawai_screen.dart';
import '../screens/pegawai_edit_screen.dart';

class MyProfileScreen extends StatelessWidget {
  void selectMenu(BuildContext context, String route, {Object arguments}) {
    Navigator.of(context)
        .pushNamed(
      route,
      arguments: arguments
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
    final user = Provider.of<Auth>(context).userId;
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[
        Text(user.toString()),
        Card(
            color: Colors.orangeAccent,
            child: InkWell(
              onTap: () => selectMenu(context, PegawaiScreen.routeName),
              child: ListTile(
                leading: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                title: Text(
                  'Edit Pegawai',
                  style: theme.textTheme.display1
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        Card(
            color: Colors.orangeAccent,
            child: InkWell(
              onTap: () => selectMenu(context, PegawaiEditScreen.routeName),
              child: ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                title: Text(
                  'Edit My Information',
                  style: theme.textTheme.display1
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        Card(
            color: Colors.red,
            child: InkWell(
              onTap: () {},
              child: ListTile(
                leading: Icon(
                  Icons.power_settings_new,
                  color: Colors.white,
                ),
                title: Text(
                  'Logout',
                  style: theme.textTheme.display1
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
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
          AppHeader('My Profile'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: createMenu(context),
          ),
        ],
      ),
    );
  }
}
