import 'package:biznet/providers/auth.dart';
import 'package:biznet/providers/pegawai.dart';
import 'package:biznet/screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_header.dart';
import '../screens/survey_screen.dart';
import '../screens/maintenance_screen.dart';
import '../screens/installation_screen.dart';
import '../screens/troubleshoot_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      'hide_if': [],
    },
    {
      'title': 'Installation',
      'icon': Icons.move_to_inbox,
      'route': InstallationScreen.routeName,
      'hide_if': ['Sales'],
    },
    {
      'title': 'Troubleshoot',
      'icon': Icons.call,
      'route': TroubleshootScreen.routeName,
      'hide_if': ['Sales'],
    },
    {
      'title': 'Maintenance',
      'icon': Icons.build,
      'route': MaintenanceScreen.routeName,
      'hide_if': ['Sales'],
    },
    {
      'title': 'History',
      'icon': Icons.history,
      'route': HistoryScreen.routeName,
      'hide_if': [],
    },
  ];

  List<Map<String, Object>> get getMenus {
    var pegawai = Provider.of<Auth>(context).pegawai?.posisi;
    return menus
        .where((f) => (f['hide_if'] as List).contains(pegawai) == false)
        .toList();
  }

  Future<dynamic> _loadFutures(context) async {
    await Provider.of<Pegawai>(context).fetchAndSet();
  }

  Widget createMenu(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder(
      future: _loadFutures(context),
      builder: (context, snapshot) => ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: getMenus
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
              .toList()),
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
          AppHeader('Work Order'),
          Padding(
            padding: EdgeInsets.only(top: 15, left: 25, right: 25),
            child: createMenu(context),
          ),
        ],
      ),
    );
  }
}
